# app/openai_utils.py
import os
from openai import OpenAI

client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

def generate_comfort_message(content: str):
    response = client.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=[
            {"role": "system", "content": "You are a supportive friend who provides comforting and reassuring messages."},
            {"role": "user", "content": f"사용자 걱정: {content}\n위로를 짧고 간단히 해줘."},
        ],
        stream=False
    )
    return response.choices[0].message.content

def generate_comfort_message_stream(content: str):
    """
    OpenAI ChatCompletion을 stream=True로 호출,
    chunk별 텍스트를 'data: ...\n\n' 형태로 yield.
    """
    try:
        stream = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": "You are a supportive friend..."},
                {"role": "user", "content": f"사용자 걱정: {content}\n위로를 짧고 간단히 해줘."},
            ],
            stream=True
        )
        for chunk in stream:
            yield chunk.choices[0].delta.content or ""

    except Exception as e:
        # 에러 시 SSE로도 알려줄 수 있음
        yield f"data: Error occurred: {str(e)}\n\n"