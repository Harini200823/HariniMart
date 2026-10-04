package com.harini.harinimart.service;

import com.harini.harinimart.dao.UserDAO;
import com.harini.harinimart.dao.UserDAOImpl;
import com.harini.harinimart.model.User;
import org.mindrot.jbcrypt.BCrypt;

public class UserServiceImpl implements UserService {
    private UserDAO userDAO = new UserDAOImpl();

    @Override
    public boolean registerUser(User user) {
        String hashedPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
        user.setPassword(hashedPassword);

        return userDAO.registerUser(user);
    }

    @Override
    public User loginUser(String email, String password) {
        return userDAO.loginUser(email, password);
    }

    @Override
    public boolean isEmailRegistered(String email) {
        return userDAO.isEmailRegistered(email);
    }
}