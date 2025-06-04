from openai import OpenAI

api_key = 'bd212ec4f7ec781ab275749b52ac6fc1249795a488ecacf79e3590face11ec01'
base_url = 'https://aiplatform.dev51.cbf.dev.paypalinc.com/cosmosai/llm/v1'

client = OpenAI(
    api_key = api_key,
    base_url = base_url
)

messages = [{"role": "user", "content": "Hi, who are you."}]

models = client.models.list()

for model in models:
    try:
        response = client.chat.completions.create(
            model=model.id,
            messages=messages,
            max_tokens=64,
            temperature=0
        )
        print(f'{model.id} response: {response.choices[0].message.content.lstrip()}')
    except Exception as e:
        print(f'{model.id} is taking a nap and dreaming in glitches. Might need a reboot or a cup of digital coffee!')
