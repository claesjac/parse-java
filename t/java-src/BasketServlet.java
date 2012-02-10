package bookletski;

import java.io.IOException;

import java.util.Iterator;

import javax.mail.MessagingException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class BasketServlet extends ActionServlet {
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

        /* Register callbacks */
        registerAction("add", "addItem");
        registerAction("remove", "removeItem");
        registerAction("send", "sendOrder");
    }

    public void addItem(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        if (session != null) {
            User u = (User) session.getAttribute("myUser");
            if (u != null && u.isLoggedIn()) {
                String id = request.getParameter("id");
                if (id != null && id.matches("\\d+")) {
                    Basket b = (Basket) session.getAttribute("myBasket");
                    if (b != null) {
                        b.add(Integer.parseInt(id));
                    }
                }
                else {
                    session.setAttribute("error", "Kunde int tolka 'id' som ett tal");
                    response.sendRedirect(request.getContextPath() + "/error.jsp");
                    return;
                }
            }
            else {
                session.setAttribute("error", "Du &auml;r inte inloggad");
                response.sendRedirect(request.getContextPath() + "/error.jsp");
                return;
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/basket.jsp");
        return;
    }
    
    public void removeItem(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        if (session != null) {
            User u = (User) session.getAttribute("myUser");
            if (u != null && u.isLoggedIn()) {
                String id = request.getParameter("id");
                if (id != null && id.matches("\\d+")) {
                    Basket b = (Basket) session.getAttribute("myBasket");
                    if (b != null) {
                        b.remove(Integer.parseInt(id));
                    }
                }
                else {
                    session.setAttribute("error", "Kunde int tolka 'id' som ett tal");
                    response.sendRedirect(request.getContextPath() + "/error.jsp");
                    return;
                }
            }
            else {
                session.setAttribute("error", "Du &auml;r inte inloggad");
                response.sendRedirect(request.getContextPath() + "/error.jsp");
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/basket.jsp");
        return;
    }
    
    public void sendOrder(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        if (session == null) {
            session.setAttribute("error", "Du &auml;r inte inloggad");
            response.sendRedirect(request.getContextPath() + "/error.jsp");
            return;
        }
        
        User u = (User) session.getAttribute("myUser");
        if (u == null || !u.isLoggedIn()) {
            session.setAttribute("error", "Du &auml;r inte inloggad");
            response.sendRedirect(request.getContextPath() + "/error.jsp");
            return;
        }
        
        Basket b = (Basket) session.getAttribute("myBasket");
        if (b == null || b.isEmpty()) {
            session.setAttribute("error", "Din varukorg &auml;r tom");
            response.sendRedirect(request.getContextPath() + "/error.jsp");
            return;            
        }

        String from = "whoami@internet";
        String to   = u.getEmail();

        try {
            /* Construct message */
            String body = "The following books has been added to the waiting list:\n\n";
            body += "----------------\n\n";
            
            Iterator i = b.contents().iterator();
            while (i.hasNext()) {
                Book book = (Book) i.next();
                body += "\t" + book.getTitle() + "\n";
            }
            body += "\n----------------\n\n";
            body += "When a book is available you will be notified via email\n\n";
            body += "thanks for using Bookletski!\n";
            
            EmailUtils.send(from, to, "Bookletski! Your recent order", body);
            EmailUtils.send(from, "whoami@internet", "Bookletski! Order by  " + u.getName(), body);

            /* Empty basket */
            b.clear();

            session.setAttribute("reciept", body);
            response.sendRedirect(request.getContextPath() + "/reciept.jsp");
            return;                    
            
        }
        catch (MessagingException e) {
            throw new ServletException(e.getMessage(), e);
        }
    }
}
    
