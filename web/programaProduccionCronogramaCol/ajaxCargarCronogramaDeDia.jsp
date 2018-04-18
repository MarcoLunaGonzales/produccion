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
String fecha = (request.getParameter("fecha")==null)?"0":request.getParameter("fecha");
String[] fechaArray=fecha.split("/");
String fechaFormato=fechaArray[2]+"/"+fechaArray[1]+"/"+fechaArray[0];


SimpleDateFormat sdf= new SimpleDateFormat("HH:mm");
        

                    String  consulta="select m.COD_MAQUINA,m.NOMBRE_MAQUINA from MAQUINARIAS m  where m.COD_MAQUINA in (" +
                                     " select DISTINCT ppcd.COD_MAQUINA"+
                                     " from PROGRAMA_PRODUCCION_CRONOGRAMA ppc inner join PROGRAMA_PRODUCCION_CRONOGRAMA_DETALLE ppcd on"+
                                     " ppc.COD_ESTADO_PROGRAMA_PRODUCCION_CRONOGRAMA =1 and "+
                                     " ppc.COD_PROGRAMA_PRODUCCION_CRONOGRAMA=ppcd.COD_PROGRAMA_PRODUCCION_CRONOGRAMA"+
                                     " where ppcd.FECHA_INICIO BETWEEN '"+fechaFormato+" 00:00:00' and '"+fechaFormato+" 23:59:59'  )";
                    Connection con=null;
                    con=Util.openConnection(con);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet res=st.executeQuery(consulta);
                    Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet resDetalle;
                    
                        out.println("<table id='ProgProdCronograma' class='class='border'>");
                        out.println("<tr class='headerClassACliente outputText2'>");
                        List<List<String>> valores= new ArrayList<List<String>>();
                        valores.clear();
                        int contAux=0;
                        int contRow=0;
                        while(res.next())
                        {
                            out.println("<td  ><div width='120px'>"+res.getString("NOMBRE_MAQUINA")+"<div></td><td>Hora</td>");
                            consulta=" select ppc.COD_PROGRAMA_PRODUCCION_CRONOGRAMA,cp.nombre_prod_semiterminado,ppc.COD_LOTE_PRODUCCION,ppp.NOMBRE_PROGRAMA_PROD,ppcd.FECHA_FINAL,ppcd.FECHA_INICIO,afm.ORDEN_ACTIVIDAD"+
                                     " from PROGRAMA_PRODUCCION_CRONOGRAMA ppc inner join PROGRAMA_PRODUCCION_CRONOGRAMA_DETALLE ppcd"+
                                     " on ppc.COD_PROGRAMA_PRODUCCION_CRONOGRAMA=ppcd.COD_PROGRAMA_PRODUCCION_CRONOGRAMA"+
                                     " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=ppc.COD_COMPPROD "+
                                     " inner join PROGRAMA_PRODUCCION_PERIODO ppp on ppp.COD_PROGRAMA_PROD=ppc.COD_PROGRAMA_PROD" +
                                     " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA=ppc.COD_FORMULA_MAESTRA and "+
                                     " fm.COD_ESTADO_REGISTRO=1 inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_FORMULA_MAESTRA="+
                                     " fm.COD_FORMULA_MAESTRA and afm.COD_AREA_EMPRESA=96 and afm.COD_ESTADO_REGISTRO=1"+
                                     " inner join MAQUINARIA_ACTIVIDADES_FORMULA maf on maf.COD_ACTIVIDAD_FORMULA=afm.COD_ACTIVIDAD_FORMULA"+
                                     " and maf.COD_ESTADO_REGISTRO=1 and maf.COD_MAQUINA=ppcd.COD_MAQUINA"+
                                     " where ppcd.COD_MAQUINA='"+res.getString("COD_MAQUINA")+"' " +
                                     " and ppcd.FECHA_INICIO BETWEEN '"+fechaFormato+" 00:00:00'  and '"+fechaFormato+" 23:59:59' order by ppcd.FECHA_INICIO";
                            System.out.println("consulta cargar prod "+consulta);
                            resDetalle=stDetalle.executeQuery(consulta);
                            List<String> lista= new ArrayList<String>();
                            contAux=0;
                            while(resDetalle.next())
                            {
                                lista.add(resDetalle.getString("nombre_prod_semiterminado")+"("+resDetalle.getString("COD_LOTE_PRODUCCION")+")#"+resDetalle.getString("ORDEN_ACTIVIDAD")+"#"+sdf.format(resDetalle.getTimestamp("FECHA_INICIO"))+"#"+sdf.format(resDetalle.getTimestamp("FECHA_FINAL"))+"#"+resDetalle.getString("COD_PROGRAMA_PRODUCCION_CRONOGRAMA"));
                                contAux++;
                            }

                            valores.add(lista);
                            if(contAux>contRow)
                            {
                                contRow=contAux;
                            }

                        }
                        System.out.println("fila "+contRow);
                        for(int fila=0;fila<contRow;fila++)
                        {
                            out.println("<tr class='outputText2'>");
                            for(int col=0;col<valores.size();col++)
                            {
                                if(fila<valores.get(col).size())
                                    {
                                        String[] mostrar=valores.get(col).get(fila).split("#");
                                        out.println("<td onmousedown='seleccion(this)'><input type='hidden' value='"+mostrar[4]+"'/><span>("+mostrar[1]+") </span>"+mostrar[0]+"</td><td><input type='text' value='"+mostrar[2]+"' style='width:36px'/><input type='text' value='"+mostrar[3]+"' style='width:36px'/></td>");
                                    }
                                else
                                {
                                    out.println("<td></td><td></td>");
                                }
                            }
                            out.println("</tr>");
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
