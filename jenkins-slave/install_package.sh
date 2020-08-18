#!/bin/bash
tool_loc=/opt/tools
java_package_name='zulu8.40.0.25-ca-jdk8.0.222-linux_x64'
java_package_url="https://cdn.azul.com/zulu/bin/${java_package_name}.tar.gz"

gradle_package_name='gradle-6.4.1'
gradle_package_url="https://services.gradle.org/distributions/${gradle_package_name}-bin.zip"


bootstrap (){
    mkdir -p "${tool_loc}"
}


install_java () {
    cd "${tool_loc}" && wget "${java_package_url}"
    tar -xzf "${java_package_name}".tar.gz
    mv "${java_package_name}" java
}

install_gradle () {
    cd "${tool_loc}" && wget "${gradle_package_url}"
    unzip  gradle-*.zip && mv "${gradle_package_name}" gradle
}

bootstrap
install_java
install_gradle