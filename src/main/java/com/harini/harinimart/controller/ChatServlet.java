package com.harini.harinimart.controller;

import com.google.gson.Gson;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/api/chat")
public class ChatServlet extends HttpServlet {
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> jsonResponse = new HashMap<>();
        try {
            StringBuilder sb = new StringBuilder();
            String line;
            try (BufferedReader reader = request.getReader()) {
                while ((line = reader.readLine()) != null) {
                    sb.append(line);
                }
            }
            
            @SuppressWarnings("unchecked")
            Map<String, String> body = gson.fromJson(sb.toString(), Map.class);
            String userMessage = body != null ? body.get("message") : "";

            // Input validation
            if (userMessage == null || userMessage.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                jsonResponse.put("success", false);
                jsonResponse.put("data", null);
                Map<String, String> error = new HashMap<>();
                error.put("code", "VALIDATION_ERROR");
                error.put("message", "Message cannot be empty");
                jsonResponse.put("error", error);
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            // Simple Domain FAQ replies
            String reply = getDomainReply(userMessage);

            // Success JSON response envelope
            jsonResponse.put("success", true);
            Map<String, String> data = new HashMap<>();
            data.put("reply", reply);
            jsonResponse.put("data", data);
            jsonResponse.put("error", null);
            response.setStatus(HttpServletResponse.SC_OK);

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.put("success", false);
            jsonResponse.put("data", null);
            Map<String, String> error = new HashMap<>();
            error.put("code", "SERVER_ERROR");
            error.put("message", "Chatbot service temporarily unavailable.");
            jsonResponse.put("error", error);
        }
        response.getWriter().write(gson.toJson(jsonResponse));
    }

    private String getDomainReply(String msg) {
        msg = msg.toLowerCase();
        if (msg.contains("shipping") || msg.contains("delivery")) {
            return "HariniMart offers standard delivery within 3-5 business days across all categories!";
        } else if (msg.contains("return") || msg.contains("refund")) {
            return "You can request a return within 7 days of order delivery from your Order History page.";
        } else if (msg.contains("payment") || msg.contains("pay")) {
            return "HariniMart supports secure mock payment confirmations during checkout.";
        } else if (msg.contains("seller") || msg.contains("list")) {
            return "Sellers can add, edit, or remove product listings directly from their seller dashboard.";
        } else {
            return "I am your HariniMart assistant! Ask me about products, shipping, orders, or return policies.";
        }
    }
}