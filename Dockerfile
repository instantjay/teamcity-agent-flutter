FROM jetbrains/teamcity-agent

# Set up the timezone since its sometimes required by certain tools/apps
ARG timezone=Asia/Shanghai
ENV DEBIAN_FRONTEND noninteractive

ENV SDK_TOOLS_VERSION "4333796"
ENV FLUTTER_VERSION "1.2.1"
ENV TARGET_ANDROID_SDK "28"
ENV ANDROID_BUILD_TOOLS_VERSION "28.0.3"
ENV ANDROID_HOME "/opt/sdk"
ENV FLUTTER_HOME "/opt/flutter"

RUN echo ${timezone} > /etc/localtime
RUN apt update && apt install tzdata unzip wget default-jdk xz-utils curl lib32stdc++6 -y

WORKDIR /tmp

# Install the Android build tools
RUN wget -nv https://dl.google.com/android/repository/sdk-tools-linux-${SDK_TOOLS_VERSION}.zip && unzip sdk-tools-linux-${SDK_TOOLS_VERSION}.zip -d ${ANDROID_HOME}
ENV PATH="${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${PATH}"
RUN sdkmanager --update && yes | sdkmanager "platform-tools" "tools" "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" "platforms;android-${TARGET_ANDROID_SDK}"

# Install the Flutter specific tools
RUN wget -nv https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v${FLUTTER_VERSION}-stable.tar.xz 
RUN mkdir ${FLUTTER_HOME} && tar xf flutter_linux_v${FLUTTER_VERSION}-stable.tar.xz -C /opt
ENV PATH="${FLUTTER_HOME}/bin:${PATH}"

#RUN flutter config --android-sdk ${ANDROID_HOME}/platforms/android-${TARGET_ANDROID_SDK}
RUN yes | flutter doctor --android-licenses