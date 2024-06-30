# RAG
Login to the instance.

## Install code
Clone my repo:
```shell
cd
git clone https://github.com/perbergman/ragtime.git
```

Get neo4j RAG repo.
```shell
cd
git clone https://github.com/docker/genai-stack.git
```

Switch to the exact commit:
```shell
cd genai-stack
git checkout 91917399c413a127fe048b5894a343018a50f98f
```

Copy the files from the ragtime repo to the genai-stack repo.
```shell
cd ..
cp ragtime/config/sample.env genai-stack/.env
cp ragtime/config/docker-compose.yml genai-stack
cp ragtime/config/down.sh genai-stack
cp ragtime/config/up.sh genai-stack
```

Edit the .env file:
LANGCHAIN_API_KEY=TBD
OPENAI_API_KEY=TBD

```shell
cd genai-stack
vi .env
```

Start the containers:
```shell
cd genai-stack
sudo mkdir data
sudo chmod 777 data
./up.sh
```

