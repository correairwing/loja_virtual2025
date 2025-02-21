package com.icorrea.loja_virtual;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@EntityScan(basePackages = {"com.icorrea.loja_virtual.models"})
@EnableJpaRepositories(basePackages = {"com.icorrea.loja_virtual.repository"})
@EnableTransactionManagement
@SpringBootApplication
public class LojaVirtualApplication {
    public static void main(String[] args) {

        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        String senha = "123";
        String hash = encoder.encode(senha);

        System.out.println("Senha criptografada: " + hash);

        SpringApplication.run(LojaVirtualApplication.class, args);
    }

}
