import argparse
import os
import sys
import pdfplumber
from unidecode import unidecode
import tiktoken
from openai import OpenAI

client = OpenAI(
    base_url=os.environ["OPENAI_BASE_URL"],
    api_key=os.environ["OPENAI_API_KEY"],
)

MODEL = "gpt-4-32k-0613"
SHELL = "zsh"
OS_ENV = "NixOS"
CONTEXT_ENV = f"""
Use the following information to help the user with whatever they need:

SESSION AND USER SYSTEM INFORMATION:
This inference session is running via a CLI utility, which was executed in a {SHELL} shell on the user's {OS_ENV} system. 

YOUR RESPONSE WILL BE STREAMED TO STDOUT
This may be used in many creative ways, such as redirecting output to a file or piping it to another CLI utility. 
You may suggest or instruct the user on utilising this fact to achieve any goals they may have.
However, if the user's query does not mention or relate to the above then DO NOT REFERENCE ANY OF THIS 
"""
CONTEXT_XPDF = """
Follow the user's instructions regarding the content within `RefRawText` above.
"""
CONTEXT_REF = """
Follow the user's instructions regarding the content within `RefText` above.
"""

parser = argparse.ArgumentParser(
    prog="Python Artificial Command Line Intelligence",
    description="Access OpenAI's API via cli for quick assistance right here in your terminal.",
)
parser.add_argument(
    "--chat",
    "-c",
    action="store_true",
    help="Enable a dialog with follow-up responses.",
)
parser.add_argument(
    "--model",
    type=str,
    default=MODEL,
    help=f"Which model to use. Default is {MODEL}.",
)
parser.add_argument(
    "--show-models",
    action="store_true",
    help="Print models supported by endpoint.",
)
parser.add_argument(
    "--nostream", action="store_true", help="Don't stream the response."
)
parser.add_argument(
    "--envinfo",
    "-e",
    action="store_true",
    help="Include system environment info in system prompt.",
)
parser.add_argument(
    "--no-fluff",
    "-nf",
    action="store_true",
    help="Print nothing except AI output.",
)
parser.add_argument(
    "--full-fluff",
    "-ff",
    action="store_true",
    help="Print lots of fluffy formatting around AI output.",
)
parser.add_argument(
    "--prompt-file",
    "-p",
    type=str,
    default=None,
    help="Send content of given file as prompt.",
)
parser.add_argument(
    "--out-file",
    "-o",
    type=str,
    default=None,
    help="Append output to the given file.",
)
parser.add_argument(
    "--count-tokens",
    action="store_true",
    help="Outputs estimated token count of given prompt.",
)
parser.add_argument(
    "--sys-prompt",
    type=str,
    default=None,
    help="Override the system prompt.",
)
parser.add_argument(
    "--temp",
    type=float,
    default=0.5,
    help="The temperature parameter for AI text generation.",
)
parser.add_argument(
    "--max-tokens",
    type=int,
    default=2000,
    help="The max tokens for AI text generation.",
)
parser.add_argument(
    "--ref-file",
    type=str,
    default=None,
    help="Specify file to add its contents as a reference in the system prompt.",
)
parser.add_argument(
    "--xpdf",
    type=str,
    default=None,
    help="Specify pdf file to add its contents as a reference in the system prompt.",
)
parser.add_argument(
    "--xpdf-start",
    type=int,
    default=0,
    help="Specify the start page number for pdf extraction.",
)
parser.add_argument(
    "--xpdf-end",
    type=int,
    default=0,
    help="Specify the end page number for pdf extraction (inclusive).",
)
parser.add_argument(
    "message",
    nargs="*",
    help="Everything after last argument is the prompt message. If empty, you will be prompted.",
)
args = parser.parse_args()

if args.show_models:
    model_names = sorted([model.id for model in client.models.list()])
    for name in model_names:
        print(name)
    exit()

BASE_SYSTEM_PROMPT = (
    "You are a helpful AI assistant.\n"
    if not args.sys_prompt
    else (args.sys_prompt + "\n")
)
messages = [
    {
        "role": "system",
        "content": f"{BASE_SYSTEM_PROMPT}",
    },
]


def append_file_content(filepath, content):
    with open(filepath, "a") as file:
        file.write(content)


def output(msg="", end="\n", fluff_lvl=0):
    if fluff_lvl > 0 and args.no_fluff:
        return
    elif fluff_lvl > 2 and not args.full_fluff:
        return
    print(msg, end=end)
    if args.out_file:
        append_file_content(args.out_file, msg + end)


def get_file_content(filepath):
    if os.path.exists(filepath):
        with open(filepath, "r") as file:
            file_data = file.read()
            return file_data
    else:
        return ""


def show_token_count():
    token_count = len(tiktoken.encoding_for_model(args.model).encode(messages))
    print(f"Token count: {token_count}")


def extract_pdf(pdf_file, start, end):
    content = ""
    with pdfplumber.open(pdf_file) as pdf:
        if not start:
            start = 1
        if not end:
            end = len(pdf.pages)
        for page_num in range(start, end + 1):
            page = pdf.pages[page_num - 1]
            page_content = page.extract_text()
            # convert non-ascii characters to the closest possible ASCII representation
            ascii_content = unidecode(page_content)
            content += ascii_content
    return content


def get_pdf_context():
    raw_pdf_text = extract_pdf(args.xpdf, args.xpdf_start, args.xpdf_end)
    return "RefRawText: {\n" + raw_pdf_text + "\n}\n\n"


def get_ref_file_context():
    return "RefText: {\n" + get_file_content(args.ref_file) + "\n}\n\n"


def update_system_prompt():
    extra_context = ""
    if args.envinfo or not sys.stdin.isatty():
        extra_context += CONTEXT_ENV
        if not sys.stdin.isatty():
            extra_context += (
                "The following was piped in by the user:\nPipedContent: {\n"
                + sys.stdin.read()
                + "\n}\n\n"
            )
            sys.stdin.close()
            sys.stdin = os.fdopen(1)
            if args.out_file:
                extra_context += "NOTE: USER IS REDIRECTING RESPONSE INTO A FILE\nAssume they are redirecting it into the correct file and do not mention this.\n"

    if args.xpdf:
        extra_context += get_pdf_context() + CONTEXT_XPDF
    if args.ref_file:
        extra_context += get_ref_file_context() + CONTEXT_REF

    messages[0]["content"] = f"{BASE_SYSTEM_PROMPT}{extra_context}"


update_system_prompt()


def add_message(role: str, content: str):
    message = {"role": role, "content": content}
    messages.append(message)


def chat_completion(messages):
    if args.count_tokens:
        show_token_count()

    completion = client.chat.completions.create(
        stream=not args.nostream,
        model=args.model,
        messages=messages,
        temperature=args.temp,
        max_tokens=args.max_tokens,
    )
    output("## AI Response:", fluff_lvl=2)
    if args.nostream:
        reply = completion.choices[0].message.content
        output(reply, end="", fluff_lvl=0)
    else:
        reply = ""
        for chunk in completion:
            reply_delta = chunk.choices[0].delta.content
            if not reply_delta:
                continue
            output(reply_delta, end="", fluff_lvl=0)
            reply += reply_delta
    add_message("assistant", reply)
    output()

    return reply


def init_prompt():
    def formatted_prompt_output(prompt):
        output(
            f"## System Prompt:\n```\n{messages[0]['content']}```\n\n## ",
            end="",
            fluff_lvl=3,
        )
        output(
            f"Prompt:\n{prompt}\n\n",
            fluff_lvl=1,
        )
        output("-------\n", fluff_lvl=2)

    if args.prompt_file:
        prompt = get_file_content(args.prompt_file)
        if prompt:
            formatted_prompt_output(prompt)
            add_message("user", prompt)
        else:
            output("Invalid file content.")
            exit()
    else:
        prompt = " ".join(args.message)
        if prompt == "":
            prompt = input("Enter message:\n> ")
        else:
            formatted_prompt_output(prompt)
        add_message("user", prompt)


init_prompt()

reply = chat_completion(messages)

while 1:
    if args.chat:
        output("\n-------\n", fluff_lvl=2)
        choice = input("\n Press enter to continue or q to quit...")
        if choice and choice[0] == "q":
            break
        prompt = input("> ")
        output(
            f"## follow-up Prompt:\n{prompt}\n\n",
            fluff_lvl=2,
        )
        output("-------\n", fluff_lvl=2)
        add_message("user", prompt)
        reply = chat_completion(messages)
        continue
    break
