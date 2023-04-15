FROM consol/rocky-xfce-vnc:v2.0.1
USER 0
# 安装中文 pip3 pywpsrpc
RUN dnf install -y mesa-libGLU \
    && dnf install -y qt5-qttools-devel \ 
    && dnf install -y libpng* \
    && dnf install -y libXss* \
    && dnf install -y glibc-langpack-zh \
    && dnf install -y python3-pip \
    && dnf clean all \
    && pip3 install jinja2 aiofiles fastapi uvicorn apscheduler requests pywpsrpc -i https://pypi.tuna.tsinghua.edu.cn/simple
ADD resource.tar.gz /home
RUN cd /home \
    && rpm -ivh /home/wps-office-*.rpm \
    && cp -r Kingsoft /headless/.config/ \
    && cp ./fonts/* /usr/share/fonts/wps-office/ \
    && cp ./src/log.conf /headless/log.conf \
    && rm -rf Kingsoft \
    && rm -f wps-office-*.rpm \
    && rm -rf fonts
ENV timezone Asia/Shanghai
EXPOSE 5678
CMD cd /home/src && uvicorn convert:app --host 0.0.0.0 --port 5678 --log-level error
