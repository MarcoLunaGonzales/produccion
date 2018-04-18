<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>
<%@ page import="com.cofar.util.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%
try{
            String fechaInicio = (request.getParameter("fechaInicio")==null)?"0":request.getParameter("fechaInicio");
            String fechaFinal=(request.getParameter("fechaFinal")==null)?"0":request.getParameter("fechaFinal");
            String conRango=(request.getParameter("conRango")==null)?"0":request.getParameter("conRango");
            String codProgProdCron=(request.getParameter("codProgProdCron")==null)?"0":request.getParameter("codProgProdCron");
            String[] fechaArray=fechaFinal.split("/");
            String fechaFinalFormato=fechaArray[2]+"/"+fechaArray[1]+"/"+fechaArray[0];
            String fechaInicioFormato="";
            if(conRango.equals("1"))
            {
                fechaArray=fechaInicio.split("/");
                fechaInicioFormato=fechaArray[2]+"/"+fechaArray[1]+"/"+fechaArray[0];
            }
            else
            {
                fechaInicioFormato=fechaFinalFormato;
            }
            String conDelete="DELETE PROGRAMA_PRODUCCION_CRONOGRAMA_DETALLE where COD_PROGRAMA_PRODUCCION_CRONOGRAMA='"+codProgProdCron+"'";
            System.out.println("consulta delete detalle"+conDelete);
            Connection con=null;
            con=Util.openConnection(con);
            PreparedStatement pst=con.prepareStatement(conDelete);
            if(pst.executeUpdate()>0)System.out.println("se elimino el detalle");
            conDelete="DELETE PROGRAMA_PRODUCCION_CRONOGRAMA where COD_PROGRAMA_PRODUCCION_CRONOGRAMA='"+codProgProdCron+"'";
            System.out.println("consulta delete cabecera"+conDelete);
            pst=con.prepareStatement(conDelete);
            if(pst.executeUpdate()>0)System.out.println("se elimino la cabecera");
            SimpleDateFormat sdf= new SimpleDateFormat("HH:mm");
            String  consulta="select m.COD_MAQUINA,m.NOMBRE_MAQUINA,COUNT(ppcd.COD_MAQUINA) as cantRow"+
                             " from PROGRAMA_PRODUCCION_CRONOGRAMA ppc inner join PROGRAMA_PRODUCCION_CRONOGRAMA_DETALLE ppcd on "+
                             " ppc.COD_PROGRAMA_PRODUCCION_CRONOGRAMA=ppcd.COD_PROGRAMA_PRODUCCION_CRONOGRAMA inner join MAQUINARIAS m"+
                             " on m.COD_MAQUINA=ppcd.COD_MAQUINA  "+
                             " where ppc.COD_ESTADO_PROGRAMA_PRODUCCION_CRONOGRAMA=1 and ppcd.FECHA_INICIO BETWEEN '"+fechaInicioFormato+" 00:00:00' and '"+fechaFinalFormato+" 23:59:59'"+
                             " group by m.COD_MAQUINA,m.NOMBRE_MAQUINA order by m.COD_MAQUINA,m.NOMBRE_MAQUINA";
            System.out.println("consulta maq "+consulta);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet resDetalle;
            out.println("<table id='ProgProdCronograma' border=1 cellspacing=0 cellpadding=2 bordercolor='666633' class='border'>");
            while(res.next())
            {
                out.println("<tr class='outputText2' ><th class='headerCol outputText2' rowspan='"+res.getInt("cantRow")+"'>"+res.getString("NOMBRE_MAQUINA")+"</th>");
                consulta="select ppc.COD_PROGRAMA_PRODUCCION_CRONOGRAMA,cp.nombre_prod_semiterminado,ppc.COD_LOTE_PRODUCCION,"+
                         " ppp.NOMBRE_PROGRAMA_PROD,ppcd.FECHA_FINAL,ppcd.FECHA_INICIO,afm.ORDEN_ACTIVIDAD from PROGRAMA_PRODUCCION_CRONOGRAMA ppc"+
                         " inner join PROGRAMA_PRODUCCION_CRONOGRAMA_DETALLE ppcd on"+
                         " ppc.COD_PROGRAMA_PRODUCCION_CRONOGRAMA = ppcd.COD_PROGRAMA_PRODUCCION_CRONOGRAMA"+
                         " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = ppc.COD_COMPPROD inner join PROGRAMA_PRODUCCION_PERIODO ppp on ppp.COD_PROGRAMA_PROD ="+
                         " ppc.COD_PROGRAMA_PROD inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA ="+
                         " ppc.COD_FORMULA_MAESTRA and fm.COD_ESTADO_REGISTRO = 1 inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_FORMULA_MAESTRA ="+
                         " fm.COD_FORMULA_MAESTRA and afm.COD_AREA_EMPRESA = 96 and afm.COD_ESTADO_REGISTRO = 1"+
                         " inner join MAQUINARIA_ACTIVIDADES_FORMULA maf on maf.COD_ACTIVIDAD_FORMULA = afm.COD_ACTIVIDAD_FORMULA and maf.COD_ESTADO_REGISTRO = 1 "+
                         " and maf.COD_MAQUINA = ppcd.COD_MAQUINA where ppcd.COD_MAQUINA = '"+res.getString("COD_MAQUINA")+"' and "+
                         " ppcd.FECHA_INICIO BETWEEN '"+fechaInicioFormato+" 00:00:00' and '"+fechaFinalFormato+" 23:59:59' order by ppcd.FECHA_INICIO";
                resDetalle=stDetalle.executeQuery(consulta);
                System.out.println("consulta "+consulta);
                if(resDetalle.next())
                {
                    out.println("<th onmousedown='seleccion(this)' ondblclick='mostrarDetalle(this)' class='outputText2'> <input type='hidden' value='"+resDetalle.getString("COD_PROGRAMA_PRODUCCION_CRONOGRAMA")+"'/><span class='outputText2'>"+resDetalle.getString("nombre_prod_semiterminado")+"<br>"+resDetalle.getString("COD_LOTE_PRODUCCION")+"</span></th>");
                    out.println("<th class='outputText2'><input type='text' class='celda' value='"+sdf.format(resDetalle.getTimestamp("FECHA_INICIO"))+"'/><input type='text' class='celda' value='"+sdf.format(resDetalle.getTimestamp("FECHA_FINAL"))+"'/></th></tr>");

                }
                while(resDetalle.next())
                {
                     out.println("<tr class='outputText2' ><th onmousedown='seleccion(this)' ondblclick='mostrarDetalle(this)' class='outputText2'><input type='hidden' value='"+resDetalle.getString("COD_PROGRAMA_PRODUCCION_CRONOGRAMA")+"'/>"+resDetalle.getString("nombre_prod_semiterminado")+"<br>"+resDetalle.getString("COD_LOTE_PRODUCCION")+"</th>");
                    out.println("<th class='outputText2'><input type='text' class='celda' value='"+sdf.format(resDetalle.getTimestamp("FECHA_INICIO"))+"'/><input type='text' class='celda' value='"+sdf.format(resDetalle.getTimestamp("FECHA_FINAL"))+"'/></th></tr>");

                }
                resDetalle.close();
            }
            out.println("</table>");
            stDetalle.close();
            res.close();
            st.close();
            con.close();
            }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }

                %>
