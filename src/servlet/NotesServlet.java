package servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/NotesServlet")
public class NotesServlet extends HttpServlet {

    private boolean isLoggedIn(HttpSession session) {
        if (session == null) return false;
        return session.getAttribute("userId") != null
            || session.getAttribute("username") != null;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (!isLoggedIn(session)) {
            response.sendRedirect("login.jsp");
            return;
        }


        String category = request.getParameter("category");
        if (category == null || category.trim().isEmpty()) {
            category = "core";
        }
        category = category.trim().toLowerCase();

        System.err.println("NotesServlet: category = [" + category + "]");

        // Set category attribute so JSP knows which tab is active
        request.setAttribute("category", category);

        // Forward to completely separate JSP for each category
        String targetPage;
        switch (category) {
            case "oop":
                targetPage = "notes-oop.jsp";
                break;
            case "advanced":
                targetPage = "notes-advanced.jsp";
                break;
            case "misc":
                targetPage = "notes-misc.jsp";
                break;
            case "core":
            default:
                targetPage = "notes-core.jsp";
                break;
        }

        System.err.println("NotesServlet: forwarding to [" + targetPage + "]");
        request.getRequestDispatcher(targetPage).forward(request, response);
    }
}
