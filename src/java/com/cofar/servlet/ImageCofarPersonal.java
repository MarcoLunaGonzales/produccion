/*
 * ImageCofarPersonal.java
 *
 * Created on 7 de marzo de 2008, 17:59
 */

package com.cofar.servlet;

import com.cofar.util.Util;
import java.io.*;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Random;

import javax.servlet.*;
import javax.servlet.http.*;


/**
 *
 * @author jmoya
 * @version
 */
public class ImageCofarPersonal extends HttpServlet {
    
    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     */
    private Connection con;
    private String path="";
    
    public void init(ServletConfig config) throws ServletException{
        super.init(config);
        try {
            con=Util.openConnection(con);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        path=config.getServletContext().getRealPath("");
    }
    
    
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
        
        String codpersonal=request.getParameter("codpersonal");
        String icontemp=request.getParameter("icontemp");
        if(codpersonal!=null ){
            printImage(request,response);
        } else if(icontemp!=null){
            printImageTemp(request,response);
        } else{
            loadImage(request,response);
        }
        
    }
    
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
    
    /** Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
        
        processRequest(request, response);
        
    }
    public void loadImage(HttpServletRequest request, HttpServletResponse response) throws IOException{
        
        String pathIcon=(String)request.getSession().getAttribute("pathIcon");
        pathIcon=(pathIcon==null)?"":pathIcon;
        if(!pathIcon.equals("")){
            File filetemp=new File(pathIcon);
            boolean fe=filetemp.delete();
            
        }
        
        
        Random random=new Random();
        int number=random.nextInt();
        number=(number<0)?Math.abs(number):number;
        request.getSession().setAttribute("pathIcon",path+"\\temp\\"+number+".cofar");
        BufferedReader input=request.getReader();
        FileOutputStream output=new FileOutputStream(new File(path+"\\temp\\"+number+".cofar"));
        String text=input.readLine();
        String values[]=new String[5];
        int index=1;
        while (text!=null){
            if(index<4){
                values[index]=text;
                index++;
            } else if(index==4){
                int in=input.read();
                while (in!=-1){
                    output.write(in);
                    in=input.read();
                }
                text=null;
            }
            text=input.readLine();
        }
        output.close();
        String ip=request.getLocalAddr();
        int port=request.getLocalPort();
        String context=request.getContextPath();
        String s="http://"+ip+":"+port+""+context+"/personal/agregarpersonal.jsf";
        System.out.println("dir:"+s);
        response.sendRedirect(s);
        
    }
    public void printImageTemp(HttpServletRequest request, HttpServletResponse response) throws FileNotFoundException, IOException{
        String pathIcon=(String)request.getSession().getAttribute("pathIcon");
        System.out.println("pathIcon:"+pathIcon);
        if(pathIcon!=null){
            FileInputStream input=new FileInputStream(pathIcon);
            response.setContentType("image/pjpeg");
            OutputStream output=response.getOutputStream();
            int read=input.read();
            while (read!=-1){
                output.write(read);
                read=input.read();
            }
            output.close();
            input.close();
            
        }
        
    }
    public void printImage(HttpServletRequest request, HttpServletResponse response) throws FileNotFoundException, IOException{
        response.setContentType("image/pjpeg");
        OutputStream output=response.getOutputStream();
        String codpersonal=request.getParameter("codpersonal");
        if(!codpersonal.equals("")){
            try {
                
                String sql="select foto_personal from personal where cod_personal="+codpersonal;
                System.out.println("sql:"+sql);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs =st.executeQuery(sql);
                InputStream input=null;
                rs.next();
                input=rs.getBinaryStream(1);
                int read=input.read();
                if(read==-1){
                    input=new FileInputStream(new File(path+"/img/UT.png"));
                    read=input.read();
                }
                while (read!=-1){
                    output.write(read);
                    read=input.read();
                }
                if(rs!=null){
                    rs.close();st.close();
                    rs=null;st=null;
                    
                }
                input.close();
                output.close();
                
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        
    }
    
    /** Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Short description";
    }
    
    // </editor-fold>
}
