<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.web.ManagedAccesoSistema" %>
<%@page import="com.cofar.util.*"%>
<%@page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@page import="javax.faces.context.ExternalContext" %>
<%@page import="javax.faces.context.FacesContext" %>
<%@page import="javax.servlet.http.HttpServletRequest" %>

<f:view>
  <html>
        <head>
            <title>SISTEMA</title>
            <body>
                <form>
            <%
            String nombreUsuario=request.getParameter("nombreUsuario");
            String usuario=request.getParameter("nombreUsuario");
            String contraseña=request.getParameter("contranaUsuario");
            String codAreaEmpresa="";
            if(contraseña!=null)
            {
                Connection con=null;
                try
                {
                    con=Util.openConnection(con); 
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    StringBuilder consulta=new StringBuilder("select isnull(a.COD_AREA_EMPRESA,uap.COD_AREA_EMPRESA) as COD_AREA_EMPRESA,um.COD_PERSONAL");
                                        consulta.append(" from USUARIOS_MODULOS um");
                                                consulta.append(" left outer join PERSONAL_TEMPORAL pt on pt.COD_PERSONAL=um.COD_PERSONAL");
                                                consulta.append(" left outer join personal p on p.COD_PERSONAL=um.COD_PERSONAL");
                                                consulta.append(" left outer join ADMINISTRADORES_TABLETA  a on a.COD_PERSONAL=p.COD_PERSONAL");
                                                consulta.append(" left outer join PERSONAL_AREA_PRODUCCION uap on uap.COD_PERSONAL=um.COD_PERSONAL");
                                        consulta.append(" where um.COD_MODULO=10");
                                                consulta.append(" and um.NOMBRE_USUARIO =?");
                                                consulta.append(" and um.CONTRASENA_USUARIO=?");
                    System.out.println("consulta buscar usuario "+consulta);
                    PreparedStatement pst=con.prepareStatement(consulta.toString());
                    pst.setString(1,nombreUsuario);System.out.println("p1:"+nombreUsuario);
                    pst.setString(2,contraseña);System.out.println("p2:"+contraseña);
                    ResultSet res=pst.executeQuery();
                    if(res.next())
                    {
                        codAreaEmpresa=res.getString("COD_AREA_EMPRESA");
                        session.setAttribute("codPersonal",String.valueOf(res.getInt("COD_PERSONAL")*4));
                        
                        session.removeAttribute("mensaje");
                        session.setAttribute("codAreaEmpresa",codAreaEmpresa);
                        out.println("<script>window.location.href=encodeURI('OmAcondicionamiento/navProgProduccion.jsf?a='+Math.random()+'&codAreaEmpresa="+codAreaEmpresa+
                                                "&d="+(new Date()).getTime()+"&p="+(res.getInt("COD_PERSONAL"))+"');</script>");
                        con.close();
                        out.println("<script>window.location.href='navegador_opciones.jsf?a='+Math.random();</script>;");
                    }
                    else
                    {
                        con.close();
                        session.setAttribute("mensaje","Usuario/contraseña incorrecta");
                        out.println("<script>window.location.href='login.jsf?codArea="+1+"';</script>;");
                    }
                    res.close();
                    st.close();
                    con.close();
                }
                catch(SQLException ex)
                {
                    ex.printStackTrace();
                }
                finally
                {
                    con.close();
                }
            }
            else
            {
                session.setAttribute("mensaje","Usuario/contraseña incorrecta");
                        response.sendRedirect("login.jsf");
            }
            %>
            
</form>
</body>
</f:view>