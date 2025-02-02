package com.icorrea.webstore.security;

import java.beans.Customizer;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true, securedEnabled = true)
public class WebConfigSecurity{
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/publico/**").permitAll()
                .anyRequest().authenticated()
            )
            .formLogin(login -> login.defaultSuccessUrl("/home", true)) // Definir redirecionamento após login

            .logout(logout -> logout.logoutSuccessUrl("/login?logout")); // Configurar logout

        return http.build();
    }
}

