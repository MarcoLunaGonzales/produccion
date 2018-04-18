/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.filter;

import com.cofar.web.ManagedAccesoSistema;
import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author DASISAQ
 */
public class filtroAccesoSistema implements Filter {
    
    private static final boolean debug = true;
    private static final String URL_FOLDER_ERROR = "errorPages";
    private static final String URL_FOLDER_RESTABLECER_CONTRASENA = "accesoSistema";
    private static final String URL_PAGINA_LOGIN = "login.jsf";
    private static final String URL_PAGINA_NO_LOGIN = "/errorPages/expired.jsf";
    private static final String URL_A4J_LIBRARY ="/a4j_3_1_0";
    // The filter configuration object we are associated with.  If
    // this value is null, this filter instance is not currently
    // configured. 
    private FilterConfig filterConfig = null;
    
    public filtroAccesoSistema() {
    }    
    
    private void doBeforeProcessing(ServletRequest request, ServletResponse response)
            throws IOException, ServletException {
        if (debug) {
            log("filtroAccesoSistema:DoBeforeProcessing");
        }

        // Write code here to process the request and/or response before
        // the rest of the filter chain is invoked.
        // For example, a logging filter might log items on the request object,
        // such as the parameters.
        /*
	for (Enumeration en = request.getParameterNames(); en.hasMoreElements(); ) {
	    String name = (String)en.nextElement();
	    String values[] = request.getParameterValues(name);
	    int n = values.length;
	    StringBuffer buf = new StringBuffer();
	    buf.append(name);
	    buf.append("=");
	    for(int i=0; i < n; i++) {
	        buf.append(values[i]);
	        if (i < n-1)
	            buf.append(",");
	    }
	    log(buf.toString());
	}
         */
    }    
    
    private void doAfterProcessing(ServletRequest request, ServletResponse response)
            throws IOException, ServletException {
        if (debug) {
            log("filtroAccesoSistema:DoAfterProcessing");
        }

        // Write code here to process the request and/or response after
        // the rest of the filter chain is invoked.
        // For example, a logging filter might log the attributes on the
        // request object after the request has been processed. 
        /*
	for (Enumeration en = request.getAttributeNames(); en.hasMoreElements(); ) {
	    String name = (String)en.nextElement();
	    Object value = request.getAttribute(name);
	    log("attribute: " + name + "=" + value.toString());

	}
         */
        // For example, a filter might append something to the response.
        /*
	PrintWriter respOut = new PrintWriter(response.getWriter());
	respOut.println("<P><B>This has been appended by an intrusive filter.</B>");
         */
    }

    /**
     *
     * @param request The servlet request we are processing
     * @param response The servlet response we are creating
     * @param chain The filter chain we are processing
     *
     * @exception IOException if an input/output error occurs
     * @exception ServletException if a servlet error occurs
     */
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {
        
        if (debug) {
            HttpServletRequest req = (HttpServletRequest) request;
            req.getSession(false);
            ManagedAccesoSistema managedAcceso = (ManagedAccesoSistema)((HttpServletRequest)request).getSession().getAttribute("ManagedAccesoSistema");
            boolean direccionPermitida = (req.getRequestURI().split("/").length == 2 ? true : 
                                                req.getRequestURI().split("/")[2].equals(this.URL_FOLDER_ERROR)
                                                        || req.getRequestURI().split("/")[2].equals(this.URL_FOLDER_RESTABLECER_CONTRASENA)
                                                        || req.getRequestURI().split("/")[2].equals(this.URL_PAGINA_LOGIN)
                                                        || req.getRequestURI().contains(this.URL_A4J_LIBRARY));
            if( (managedAcceso == null || !managedAcceso.isUsuarioLogin()) && !direccionPermitida){
                System.out.println("--------------------------------------- INICIO ACCESO DENEGADO NO LOGEADO----------------------------");
                System.out.println("intento entrar pagina no autorizada: "+req.getRequestURI());
                System.out.println("ip: "+request.getRemoteAddr());
                System.out.println("host: "+request.getRemoteHost());
                System.out.println("puerto :"+request.getRemotePort());
                System.out.println("--------------------------------------- FINAL ACCESO DENEGADO NO LOGEADO----------------------------");
                try{
                    request.getRequestDispatcher(this.URL_PAGINA_NO_LOGIN).forward(request, response);
                    return;
                }
                catch(Exception ex){
                    System.out.println(ex.getMessage());
                }
            }
        }
        chain.doFilter(request, response);
    }

    /**
     * Return the filter configuration object for this filter.
     */
    public FilterConfig getFilterConfig() {
        return (this.filterConfig);
    }

    /**
     * Set the filter configuration object for this filter.
     *
     * @param filterConfig The filter configuration object
     */
    public void setFilterConfig(FilterConfig filterConfig) {
        this.filterConfig = filterConfig;
    }

    /**
     * Destroy method for this filter
     */
    public void destroy() {        
    }

    /**
     * Init method for this filter
     */
    public void init(FilterConfig filterConfig) {        
        this.filterConfig = filterConfig;
        if (filterConfig != null) {
            if (debug) {                
                log("filtroAccesoSistema:Initializing filter");
            }
        }
    }

    /**
     * Return a String representation of this object.
     */
    @Override
    public String toString() {
        if (filterConfig == null) {
            return ("filtroAccesoSistema()");
        }
        StringBuffer sb = new StringBuffer("filtroAccesoSistema(");
        sb.append(filterConfig);
        sb.append(")");
        return (sb.toString());
    }
    
    private void sendProcessingError(Throwable t, ServletResponse response) {
        String stackTrace = getStackTrace(t);        
        
        if (stackTrace != null && !stackTrace.equals("")) {
            try {
                response.setContentType("text/html");
                PrintStream ps = new PrintStream(response.getOutputStream());
                PrintWriter pw = new PrintWriter(ps);                
                pw.print("<html>\n<head>\n<title>Error</title>\n</head>\n<body>\n"); //NOI18N

                // PENDING! Localize this for next official release
                pw.print("<h1>The resource did not process correctly</h1>\n<pre>\n");                
                pw.print(stackTrace);                
                pw.print("</pre></body>\n</html>"); //NOI18N
                pw.close();
                ps.close();
                response.getOutputStream().close();
            } catch (Exception ex) {
            }
        } else {
            try {
                PrintStream ps = new PrintStream(response.getOutputStream());
                t.printStackTrace(ps);
                ps.close();
                response.getOutputStream().close();
            } catch (Exception ex) {
            }
        }
    }
    
    public static String getStackTrace(Throwable t) {
        String stackTrace = null;
        try {
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            t.printStackTrace(pw);
            pw.close();
            sw.close();
            stackTrace = sw.getBuffer().toString();
        } catch (Exception ex) {
        }
        return stackTrace;
    }
    
    public void log(String msg) {
        filterConfig.getServletContext().log(msg);        
    }
    
}
