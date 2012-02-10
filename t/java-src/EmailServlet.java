package bookletski;

import java.io.IOException;

import javax.mail.MessagingException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class EmailServlet extends ActionServlet {
    
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

        /* Register callbacks */
        registerAction("contact", "sendContactEmail");
    }

    public void sendContactEmail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name    = request.getParameter("name");
        String email   = request.getParameter("email");
        String inquiry = request.getParameter("inquiry");
        String message = request.getParameter("message");

        if (name == null || name.trim().equals("")) {
            name = "Anonym";
        }
        
        if (email == null || email.trim().equals("")) {
            email = "whoami@internet";
        }

        if (inquiry == null) {
            inquiry = "";
        }

        if (message == null || message.trim().equals("")) {
            HttpSession session = request.getSession(true);
            session.setAttribute("error", "Inget inneh&aring;ll angivet");
            response.sendRedirect(request.getContextPath() + "/contact.jsp");
            return;            
        }

        String body = "";
        body += "Namn: " + name + "\n";
        body += "Avser: " + inquiry + "\n";
        body += "\n" + message + "\n";
		
        try {
            EmailUtils.send(email, "whoami@internet", "Bookletski! Kontakt", body);
        }
        catch (MessagingException e) {
            throw new ServletException(e.getMessage(), e);
        }
        
        response.sendRedirect(request.getContextPath() + "/contact_sent.jsp");
        
        return;
    }
}
    
