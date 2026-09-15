# Copyright 2026 NVIDIA CORPORATION & AFFILIATES
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# =============================================================================
# WARNING: This Dockerfile is for development and testing purposes only.
# Do NOT use in production environments.
# =============================================================================

FROM node:24-slim AS builder

# Build argument to specify which example to build (simple, react, or isaac)
ARG EXAMPLE_NAME=simple
ARG DEPLOYMENT_NAME=dev-server

WORKDIR /app

# Copy the specified example's source (everything except node_modules and build)
# Note: In staging repo, helpers are already copied into each example directory
COPY ${EXAMPLE_NAME}/ ./

# Copy CloudXR SDK tarball from root directory (shared by all examples)
COPY nvidia-cloudxr-*.tgz ./cloudxr-sdk.tgz

COPY webpack-nvidia-cloudxr-alias.cjs ../

# Install CloudXR SDK and dependencies
RUN npm install ./cloudxr-sdk.tgz
RUN npm install 
RUN npm run build

# Serve static files directly without Nginx
CMD ["npm", "run", "${DEPLOYMENT_NAME}", "--", "--port", "443"]