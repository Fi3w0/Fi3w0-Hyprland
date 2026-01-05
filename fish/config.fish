if status is-interactive
    # Commands to run in interactive sessions can go here

    # Minecraft server alias
    alias mc "docker exec -it mcserver rcon-cli"
end

fish_add_path /home/fiw/.spicetif


if status is-interactive
    set -Ux OLLAMA_MODELS /home/fiw/AI
    alias ai="ollama run qwen2.5-coder:7b"
end

