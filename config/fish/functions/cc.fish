function cc
    set -lx ANTHROPIC_AUTH_TOKEN ollama
    set -lx ANTHROPIC_API_KEY ""
    set -lx ANTHROPIC_BASE_URL http://localhost:11434

    ollama launch claude --model $argv
end
