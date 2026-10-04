package com.harini.harinimart.service;

import com.harini.harinimart.model.User;

public interface UserService {
    boolean registerUser(User user);
    User loginUser(String email, String password);
    boolean isEmailRegistered(String email);
}