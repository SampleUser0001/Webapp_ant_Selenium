FROM tomcat:10.1-jdk11

# Tomcatの設定
ENV CATALINA_HOME /usr/local/tomcat

# デフォルトのROOTアプリケーションを削除
RUN rm -rf ${CATALINA_HOME}/webapps/ROOT

# manager, host-managerを有効化（オプション）
RUN rm -rf ${CATALINA_HOME}/webapps/manager ${CATALINA_HOME}/webapps/host-manager

# WARファイルをwebappsにコピー
COPY ../dist/webapp-test-sample.war ${CATALINA_HOME}/webapps/

# ポート8080を公開
EXPOSE 8080

# Tomcatを起動
CMD ["catalina.sh", "run"]
