package bookletski;

import java.io.IOException;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ActionServlet extends HttpServlet {
    /** Keeps a list of registered action handlers */
    protected Map registeredAction;
    
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

        /* Initialize actions */
        registeredAction = new HashMap();
    }
    
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
        return;
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        executeAction(action, request, response);
    }

    protected void registerAction(String action, String method) throws ServletException {
        if (!isRegisteredAction(action)) {
            try {
                registeredAction.put(action, getActionHandler(method));
            }
            catch (NoSuchMethodException e) {
                throw new ServletException(e.getMessage(), e);
            }
            catch (SecurityException e) {
                throw new ServletException(e.getMessage(), e);
            }
        }
        else {
            throw new ServletException("Action '" + action + "' already registered");
        }
    }
       
    private Method getActionHandler(String method) throws NoSuchMethodException, SecurityException {
        Method m = this.getClass().getMethod(method, new Class[] { HttpServletRequest.class,
                                                                   HttpServletResponse.class });
        return m;
    }
    
    private void executeAction(String action, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (action == null) {
            response.sendError(response.SC_BAD_REQUEST, "Missing argument 'action'");
            return;
        }
        
        if(!isRegisteredAction(action)) {
            response.sendError(response.SC_BAD_REQUEST, "No handler registered for '" + action + "'");
            return;
        }

        Method m = (Method) registeredAction.get(action);
        try {
            m.invoke(this, new Object[] { request, response });
        }
        catch (IllegalAccessException e) {
            throw new ServletException(e.getMessage(), e);            
        }
        catch (IllegalArgumentException e) {
            throw new ServletException(e.getMessage(), e);            
        }
        catch (InvocationTargetException e) {
            Throwable t = e.getTargetException();

            if (t instanceof IOException) {
                throw (IOException) t;
            }
            else if(t instanceof ServletException) {
                throw (ServletException) t;
            }

            throw new ServletException(t.getMessage(), t);
        }
    }
    
    private boolean isRegisteredAction(String action) {
        return registeredAction.containsKey(action);
    }
}
