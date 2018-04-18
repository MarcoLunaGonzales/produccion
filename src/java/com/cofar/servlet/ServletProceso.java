/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.servlet;

import com.cofar.util.TaskProduccion;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Calendar;
import java.util.Timer;
import java.util.TimerTask;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author hvaldivia
 */
public class ServletProceso extends HttpServlet {
   
    Timer timer;

    private  String driver="";

    private  String user="";
    private  String password="";
    private  String host="";
    private  String database="";
    private  String uri="";
    private Connection con = null;



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
            if(!uri.equalsIgnoreCase("none")){
                url="jdbc:odbc:"+uri;
                System.out.println("url:"+url);
                con=DriverManager.getConnection(url,user,password);
            }else{
                url="jdbc:sqlserver://"+host+";user="+user+";password="+password+";databaseName="+database;
                System.out.println("url:"+url);
                con=DriverManager.getConnection(url);
            }

        timer = new Timer();
        //Connection con=getConnection();
        //Connection con=null;

        timer.schedule(new TaskProduccion(con), 5 * 1000);
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
            out.println("<title>Servlet ServletInicial</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ServletInicial at " + request.getContextPath () + "</h1>");
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

    class RemindTask extends TimerTask {
        public void run() {


            Calendar calendar=Calendar.getInstance();
            calendar.set(2012,9,23,11,44);


            while(true){


                /*java.util.Date fecha=new java.util.Date();
                if(fecha.equals(calendar.getTime())){
                    System.out.println("_________EJECUCION________");

                }else{
                    System.out.println("______FUERA_____");

                }
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException ex) {
                    ex.printStackTrace();
                }*/


                System.out.println("_________EJECUCION________");

                try {
                    Thread.sleep(3600000);
                } catch (InterruptedException ex) {
                    ex.printStackTrace();
                }



            }



        }
    }

}
