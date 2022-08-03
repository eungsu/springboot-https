# Spring Boot 내장 Tomcat에 HTTP(SSL) 적용하기

## Spring Boot 로컬 환경에서 KeyStore 생성하기

  - 아래의 명령어를 실행해서 KeyStore를 생성한다.
    - keytool : 키와 인증서를 관리하고 키 저장소에 저장하는 프로그램이다. %JAVA_HOME%/bin 폴더에 있다.
    - 주요 옵션
      * -genkey : 키를 생성한다. 
      * -alias : 키의 이름을 지정한다.
      * -storetype : 키 저장소 타입을 지정한다. 
      * -keyalg : 암호화 알고리즘을 지정한다.
      * -keystore : 키 저장소파일명을 지정한다.
```
keytool -genkey \
        -alias sample-keystore \ 
        -storetype pkcs12 \ 
        -keyalg RSA \ 
        -keystore sample-keystore.p12
```

## Spring Boot 프로젝트에 적용하기

- 위에서 생성한 **sample-keystore.p12** 파일을 Spring Boot 프로젝트의 **/src/main/resourcs** 폴더에 복사한다.
- **application.propertis** 파일에 SSL 설정을 추가한다.
```properties
### SSL 설정
server.ssl.key-store=classpath:sample-keystore.p12
server.ssl.key-store-type=PKCS12
server.ssl.key-store-password=zxcv1234
server.ssl.key-alias=sample-keystore

### HTTPS 서버 포트 지정
server.port=443
```

## Spring Boot 프로젝트에서 HTTP를 HTTPS로 리다이렉트 시키기
- Spring Boot 2.x에서는 **ServletWebServerFactory**로 HTTP에서 HTTPS로 포트를 리다이렉션할 수 있다.
- SpringBootApplication 자바 클래스에 아래 내용을 추가한다.
```java
package com.example.demo;

import org.apache.catalina.Context;
import org.apache.catalina.connector.Connector;
import org.apache.tomcat.util.descriptor.web.SecurityCollection;
import org.apache.tomcat.util.descriptor.web.SecurityConstraint;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
import org.springframework.boot.web.servlet.server.ServletWebServerFactory;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class SpringbootSslAppApplication {

	public static void main(String[] args) {
		SpringApplication.run(SpringbootSslAppApplication.class, args);
	}

	@Bean
    public ServletWebServerFactory servletContainer() {
        TomcatServletWebServerFactory tomcat = new TomcatServletWebServerFactory() {
            @Override
            protected void postProcessContext(Context context) {
                SecurityConstraint securityConstraint = new SecurityConstraint();
                securityConstraint.setUserConstraint("CONFIDENTIAL");
                SecurityCollection collection = new SecurityCollection();
                collection.addPattern("/*");
                securityConstraint.addCollection(collection);
                context.addConstraint(securityConstraint);
            }
        };
        tomcat.addAdditionalTomcatConnectors(redirectConnector());
        return tomcat;
    }

    private Connector redirectConnector() {
        Connector connector = new Connector("org.apache.coyote.http11.Http11NioProtocol");
        connector.setScheme("http");
        connector.setPort(80);
        connector.setSecure(false);
        connector.setRedirectPort(443);
        return connector;
    }
}
```

  
