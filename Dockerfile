FROM d32176c9c93d
MAINTAINER kainino1@gmail.com

RUN pacman --noconfirm -Syu base-devel supervisor git openssh ruby clang mesa qtchooser qt5-base
RUN pacman --noconfirm -S libxml2 libxslt
RUN gem install --no-document --no-user-install bundler \
 && mkdir -p /home/gitlab_ci_runner/.ssh \
 && touch /home/gitlab_ci_runner/.ssh/known_hosts
RUN git config --global push.default simple \
 && git config --global user.email "cis277@stwing.upenn.edu" \
 && git config --global user.name "auto" \
 && git clone https://bitbucket.org/kainino/277submitscripts.git /root/277submitscripts

ADD assets/setup/ /app/setup/
RUN chmod 755 /app/setup/install
RUN /app/setup/install

ADD assets/init /app/init
RUN chmod 755 /app/init

ENV TERM=screen

VOLUME ["/home/gitlab_ci_runner/data"]

ENTRYPOINT ["/app/init"]
CMD ["app:start"]
