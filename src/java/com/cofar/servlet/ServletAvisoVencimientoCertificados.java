/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.servlet;

import com.cofar.bean.util.correos.EnvioCorreoVencimientoCertificados;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Timer;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author DASISAQ-
 */
public class ServletAvisoVencimientoCertificados extends HttpServlet {

    private Connection con = null;
    Timer timer;
    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        String driver=config.getServletContext().getInitParameter("driver");
        String uri=config.getServletContext().getInitParameter("uri");
        String user=config.getServletContext().getInitParameter("user");
        String password=config.getServletContext().getInitParameter("password");
        String database=config.getServletContext().getInitParameter("database");
        String host=config.getServletContext().getInitParameter("host");
        try {
            String url="";
            Class.forName(driver);
            url="jdbc:sqlserver://172.16.10.21;user=sa;password=m0t1t4s@2009;databaseName=SARTORIUS";
                System.out.println("url:"+url);
                con=DriverManager.getConnection(url);
            

        timer = new Timer();
        timer.schedule(new EnvioCorreoVencimientoCertificados(con),1000);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            /* TODO output your page here
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ServletAvisoVencimientoCertificados</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ServletAvisoVencimientoCertificados at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
            */
        } finally { 
            out.close();
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
