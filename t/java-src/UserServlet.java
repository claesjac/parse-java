package bookletski;

import java.io.IOException;

import java.sql.SQLException;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import javax.mail.MessagingException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UserServlet extends ActionServlet {
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

        /* Register callbacks */
        registerAction("login", "loginUser");
        registerAction("logout", "logoutUser");
        registerAction("create", "createUser");
        registerAction("retrieve", "retrieveUser");
    }

    public void loginUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String login    = request.getParameter("login");
        String password = request.getParameter("password");

        UserManager manager = UserManager.getInstance();
        
        if (manager.contains(login)) {
            User u = manager.get(login);

            if (manager.authenticate(login, password)) {
                HttpSession session = request.getSession(true);
                u.setIsLoggedIn(true);
                session.setAttribute("myUser", u);
            }
            else {
                throw new ServletException("Failed to login because the password was incorrect!'");
            }
        }

        String redirect = request.getParameter("redirect");
        if (redirect == null || redirect.equals("")) {
            redirect = request.getContextPath() + "/index.jsp";
        }
        
        response.sendRedirect(redirect);
        
        return;
    }

    public void logoutUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }

    public void createUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String login = request.getParameter("login");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String name = request.getParameter("name");

        UserManager manager = UserManager.getInstance();
        
        HttpSession session = request.getSession(true);
        List errors = new LinkedList();
        
        /* Validate login */
        if (login == null || login.trim().equals("")) {
            errors.add("Saknar anv&auml;ndarnamn.");
        }
        else {
            login = login.trim();
            if (login.length() < 5) {
                errors.add("Anv&auml;ndarnamnet &auml;r f&ouml;r kort.");
            }
            if (login.indexOf(":") >= 0) {
                errors.add("Anv&auml;ndarnamnet f&aring;r inte inneh&aring;lla ':'.");
            }
            if (manager.contains(login)) {
                errors.add("Anv&auml;ndarnamnet &auml;r upptaget.");
            }
        }

        /* Validate password */
        if (password == null || password.trim().equals("")) {
            errors.add("Saknar l&ouml;senord.");
        }
        else {
            password = password.trim();
            if (password.length() < 5) {
                errors.add("L&ouml;senordet &auml;r f&ouml;r kort.");
            }
            if (password.indexOf(":") >= 0) {
                errors.add("L&ouml;senordet f&aring;r inte inneh&aring;lla ':'.");
            }
        }
        
        /* Validate email */
        if (email == null || email.trim().equals("")) {
            errors.add("Saknar epost-adress.");
        }
        else {
            email = email.trim();
            if (!email.matches(".+@.+\\.\\w{2,}")) {
                errors.add("Angiven epost-adress ser inte ut att vara giltig.");
            }
            if (email.indexOf(":") >=0) {
                errors.add("Epost-adressen f&aring;r inte inneh&aring;lla ':'.");
            }
        }
        
        if (name == null || name.trim().equals("")) {
            name = login;
        }
        else {
            if (name.indexOf(":") >= 0) {
                errors.add("Namnet f&aring;r inte innh&aring;lla ':'.");
            }
        }
        
        if (errors.size() > 0) {
            session.setAttribute("errors", errors);
            response.sendRedirect(request.getContextPath() + "/create_user.jsp");
            return;
        }

        try {
            User u = manager.create(login, password, email, name);
            u.setIsLoggedIn(true);
            session.setAttribute("myUser", u);
        }
        catch (SQLException e) {
            throw new ServletException(e.getMessage(), e);
        }
        
        
        response.sendRedirect(request.getContextPath() + "/created_user_ok.jsp");
        return;
    }

    public void retrieveUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String login = request.getParameter("login");
        String to    = request.getParameter("email");

        UserManager manager = UserManager.getInstance();
        List userList = new LinkedList();
        
        if (login != null && manager.contains(login)) {
            User u = manager.get(login);
            
            userList.add(u);
            to = u.getEmail();
        }
        else if (to != null) {
            userList = manager.findUsersWithEmail(to);
        }

        if (userList.size() > 0) {
            try {
                String messageBody = "The following users was found registered to: " + to + "\n\n";
            
                Iterator i = userList.iterator();
                while (i.hasNext()) {
                    User u = (User) i.next();
                    messageBody += "Login '" + u.getLogin() + "' with password '" + u.getPassword() + "'\n";
                }

                EmailUtils.send("whoami@internet", to, "Bookletski! Password retrieval", messageBody);
            }
            catch (MessagingException e) {
                throw new ServletException(e.getMessage(), e);
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }
}
    
