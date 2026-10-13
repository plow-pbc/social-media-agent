FROM public.ecr.aws/e1h7x4a2/plow-cloud-agents:base-ddbaa6bc0f9e071d9411777b91590e755e367d84@sha256:5b0ebf5e33514b09f0f22f1c14424a19b4eb3fc21adfaeb260002f76d362478c

# A cloud install starts this image directly, without compose.yml. Agent Index
# identity and metadata therefore belong in the image.
ENV AGENT_ID=social-media-agent \
    AGENT_NAME="Social Media Agent" \
    AGENT_BLURB="An OpenClaw 2.0 social engagement lead that monitors X and LinkedIn, coordinates team review, and publishes only owner-approved replies." \
    AGENT_RUNTIME=OpenClaw \
    SOCIAL_HOME=/var/lib/plow/social-media \
    SOCIAL_MEDIA_CONFIG=/var/lib/plow/social-media/social-media.toml \
    SOCIAL_STATE_DB=/var/lib/plow/social-media/state.sqlite3

USER root

COPY prompt/AGENTS.md /opt/plow/prompt/AGENTS.md
COPY skills/ /opt/plow/skills/
COPY bin/social_config.py bin/social_monitor.py bin/social_state.py /opt/social-media/bin/
COPY runtime/social-media.toml.example /opt/social-media/defaults/social-media.toml

RUN chmod 0644 /opt/plow/prompt/AGENTS.md /opt/social-media/defaults/social-media.toml \
 && find /opt/plow/skills -type d -exec chmod 0755 {} + \
 && find /opt/plow/skills -type f -exec chmod 0644 {} + \
 && chmod 0755 /opt/social-media/bin/*.py

USER node
