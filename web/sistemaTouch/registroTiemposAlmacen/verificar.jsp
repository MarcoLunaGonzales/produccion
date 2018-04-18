<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>

<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.web.ManagedAccesoSistema" %>
<%@page import="com.cofar.util.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@page import="javax.faces.context.ExternalContext" %>
<%@page import="javax.faces.context.FacesContext" %>
<%@page import="javax.servlet.http.HttpServletRequest" %>

<f:view>
  <html>
  <head>
            <script type="text/javascript" src='../reponse/js/websql.js' ></script>
      </head>
       <body>
            <%
            String nombreUsuario=request.getParameter("nombreUsuario");
            String contranaUsuario=request.getParameter("contranaUsuario");
            
            if(contranaUsuario!=null)
            {
                try
                {
                    Connection con=null;
                    con=Util.openConnection(con); 
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    String consulta="select um.COD_PERSONAL,isnull(at1.COD_PERSONAL,0) as admin"+
                                    " from USUARIOS_MODULOS um left outer join ADMINISTRADORES_TABLETA at1 on "+
                                    " at1.COD_PERSONAL=um.COD_PERSONAL and at1.COD_AREA_EMPRESA=76"+
                                    " left outer join PERSONAL_AREA_PRODUCCION pap on pap.COD_PERSONAL=um.COD_PERSONAL"+
                                    " and pap.COD_AREA_EMPRESA=76"+
                                    " where um.COD_MODULO=10 and (at1.COD_PERSONAL>0 or pap.COD_PERSONAL!=0)"+
                                    " and um.NOMBRE_USUARIO ='"+nombreUsuario+"' and um.CONTRASENA_USUARIO='"+contranaUsuario+"'";
                    System.out.println("consulta verificar "+consulta);
                    ResultSet res=st.executeQuery(consulta);
                    if(res.next())
                    {
                            if(res.getInt("admin")>0)
                            {
                                out.println("<script>sqlConnection.iniciarSessionUsuario("+res.getInt("COD_PERSONAL")+",76,function(){window.location.href='navegadorProgramaProduccion.jsf?a='+(new Date()).getTime().toString()+'&p="+res.getInt("COD_PERSONAL")+"';});</script>;");
                            }
                            else
                            {
                                out.println("<script>sqlConnection.iniciarSessionUsuario("+res.getInt("COD_PERSONAL")+",76,function(){window.location.href='navegadorProgramaProduccion.jsf?a='+(new Date()).getTime().toString()+'&p="+res.getInt("COD_PERSONAL")+"';});</script>;");
                            }
                     }
                    else
                    {

                        session.setAttribute("mensaje","Usuario/contraseña incorrecta");
                        response.sendRedirect("loginAlmacen.jsf");
                    }
                        
                    
                    res.close();
                    st.close();
                    con.close();
                }
                catch(SQLException ex)
                {
                    ex.printStackTrace();
                }
            }
            else
            {
                session.setAttribute("mensaje","Usuario/contraseña incorrecta");
                        response.sendRedirect("loginAlmacen.jsf");
            }
            %>
            </body>
  </html>
</f:view>