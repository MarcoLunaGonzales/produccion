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
            String contraseniaUsuario=request.getParameter("contraseniaUsuario");
            
            if(contraseniaUsuario!=null)
            {
                try
                {
                    Connection con=null;
                    con=Util.openConnection(con); 
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    String consulta="select u.COD_PERSONAL,isnull(a.COD_AREA_EMPRESA,pap.COD_AREA_EMPRESA) as codAreaEmpresa" +
                                    " ,ISNULL(A.COD_AREA_EMPRESA,0) as administrador"+
                                    " from USUARIOS_MODULOS u left outer join PERSONAL_AREA_PRODUCCION pap"+
                                    " on pap.COD_PERSONAL=u.COD_PERSONAL"+
                                    " left outer join ADMINISTRADORES_TABLETA a on a.COD_PERSONAL=u.COD_PERSONAL"+
                                    " where u.NOMBRE_USUARIO='"+nombreUsuario+"' and u.CONTRASENA_USUARIO='"+contraseniaUsuario+"'" +
                                    " and u.COD_MODULO=10";
                    System.out.println("consulta verificar "+consulta);
                    ResultSet res=st.executeQuery(consulta);
                    if(res.next())
                    {
                        
                            if(res.getInt("administrador")>0)
                            {
                                out.println("<script>sqlConnection.iniciarSessionUsuario("+res.getInt("COD_PERSONAL")+","+res.getInt("codAreaEmpresa")+",function(){window.location.href='registroAdministrador/navegadorPeriodosTiemposAdministrador.jsf?a='+(new Date()).getTime().toString()+'&p="+(res.getInt("COD_PERSONAL"))+"&ca="+res.getInt("codAreaEmpresa")+"';});</script>;");
                            }
                            else
                            {
                                out.println("<script>sqlConnection.iniciarSessionUsuario('"+res.getInt("COD_PERSONAL")+"','"+res.getInt("codAreaEmpresa")+"',function(){window.location.href='registroTiempoPersonalIndirecto/navegadorPeriodosTiempos.jsf?a='+(new Date()).getTime().toString()+'&p="+(res.getInt("COD_PERSONAL"))+"&ca="+res.getInt("codAreaEmpresa")+"';});</script>;");
                            }
                    }
                    else
                    {

                        session.setAttribute("mensaje","Usuario/contraseña incorrecta");
                        response.sendRedirect("loginIndirectos.jsf");
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
                        response.sendRedirect("loginIndirectos.jsf");
            }
            %>
            </body>
  </html>
</f:view>