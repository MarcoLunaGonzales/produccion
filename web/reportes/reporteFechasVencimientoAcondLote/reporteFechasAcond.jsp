<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>

<%@ page import = "java.sql.*"%>
<%@ page import = "java.text.SimpleDateFormat"%>

<%@ page import = "java.util.ArrayList"%>
<%@ page import = "java.util.Date"%>
<%@ page import = "javax.servlet.http.HttpServletRequest"%>
<%@ page import = "java.text.DecimalFormat"%>
<%@ page import = "java.text.NumberFormat"%>
<%@ page import = "java.util.Locale"%>
<%@ page language="java" import="java.util.*,com.cofar.util.CofarConnection" %>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
        <script>
            function redondeo2decimales(numero)
                {
                var original=parseFloat(numero);
                var result=Math.round(original*100)/100 ;
                return result;
                }
        </script>
        <style>
            #tablaDetalle
            {
                border-top:1px solid black;
                border-left:1px solid black;
            }
            #tablaDetalle tr td
            {
                border-right:1px solid black;
                border-bottom:1px solid black;
                padding:0.5em;
            }
            #tablaDetalle  thead tr td
            {
                font-weight:bold;
            }
        </style>
    </head>
    <body>
        <form>
            <%
                        String codProgramaProd=request.getParameter("codProg");
                        String nombreProgramaProd=request.getParameter("nombreProg");
                        String codLoteBuscar=request.getParameter("codLote");
            %>
            <table align="center" width="70%" class='outputText0'>
                <thead>
                <tr>
                    <td width="10%">
                        <img src="../../img/cofar.png">
                    </td>
                    <td  align="left"><b>Programa Producción:</b></td>
                                <td align="left"><%=(nombreProgramaProd)%></td>
                        
                </tr>
                </thead>
            </table>
            <center>
                <table cellpadding="0" cellspacing="0" id="tablaDetalle" >
                    <thead>
                        <tr>
                            <td>Producto</td>
                            <td>Lote</td>
                            <td>Fecha CC.</td>
                            <td>Fecha Acond.</td>
                            <td>Fecha Apt.</td>
                        </tr>
                    </thead>
                    <tbody>
    <%
                        try {
                            Connection con=null;
                            con=Util.openConnection(con);

                            String consulta="select p.COD_LOTE_PRODUCCION,cpv.nombre_prod_semiterminado,cpv.VIDA_UTIL,"+
                                            " DATEADD(MONTH,cpv.VIDA_UTIL,("+
                                             " select  top 1 s.FECHA_INICIO from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s inner join ACTIVIDADES_FORMULA_MAESTRA"+
                                            " afm on afm.COD_ACTIVIDAD_FORMULA=s.COD_ACTIVIDAD_PROGRAMA and s.COD_FORMULA_MAESTRA=afm.COD_FORMULA_MAESTRA"+
                                            " and afm.COD_ACTIVIDAD in (76,186)"+
                                           "  where s.COD_LOTE_PRODUCCION=p.COD_LOTE_PRODUCCION"+
                                           " order by s.FECHA_FINAL DESC"+
                                           "  )) as fechaVencimiento,id.FECHA_VEN,cpv.COD_AREA_EMPRESA,cpv.COD_COMPPROD"+
                                           " from PROGRAMA_PRODUCCION p left outer join COMPONENTES_PROD_VERSION cpv on cpv.COD_COMPPROD=p.COD_COMPPROD"+
                                           "  and cpv.COD_VERSION=p.COD_COMPPROD_VERSION"+
                                           "  left outer join INGRESOS_DETALLEACOND id on id.COD_LOTE_PRODUCCION=p.COD_LOTE_PRODUCCION and "+
                                           " id.COD_COMPPROD=p.COD_COMPPROD"+
                                           " where p.COD_PROGRAMA_PROD in ("+codProgramaProd+") and p.COD_ESTADO_PROGRAMA<>3"+
                                           (codLoteBuscar.equals("")?"":" and p.COD_LOTE_PRODUCCION='"+codLoteBuscar+"' ")+
                                           " order by cpv.nombre_prod_semiterminado,p.COD_LOTE_PRODUCCION,"+
                                           " id.FECHA_VEN";

                                            System.out.println("consulta reporte "+consulta);
                               Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                               ResultSet res=st.executeQuery(consulta);
                               Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                               ResultSet resDetalle=null;
                               SimpleDateFormat sdf=new SimpleDateFormat("MM/yyyy");
                               String fechaVencimiento="";
                               String fechaAcond="";
                               String fechaApt="";
                               while(res.next())
                               {
                                   if(res.getDate("fechaVencimiento")!=null)
                                   {
                                       Calendar cal = new GregorianCalendar();
                                       cal.setTimeInMillis(res.getTimestamp("fechaVencimiento").getTime());
                                       if(res.getDate("fechaVencimiento").getDate()>=27)
                                       {

                                            cal.add(Calendar.MONTH,1);
                                       }

                                       Date fecha=new Date(cal.getTimeInMillis());
                                       fechaVencimiento=(fecha!=null?sdf.format(fecha):"&nbsp;");
                                       }
                                   else
                                   {
                                       fechaVencimiento="";
                                   }
                                   fechaAcond=(res.getTimestamp("FECHA_VEN")!=null?sdf.format(res.getTimestamp("FECHA_VEN")):"&nbsp;");
                                   
                                   if(res.getInt("COD_AREA_EMPRESA")==81)
                                   {
                                            consulta="select FECHA_VENCIMIENTO from INGRESOS_ALMACEN_DETALLE_ESTADO i inner join FORMULA_MAESTRA_DETALLE_EP_VERSION fmdep on fmdep.COD_MATERIAL = i.COD_MATERIAL" +
                                            " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA = fmdep.COD_FORMULA_MAESTRA inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = fm.COD_COMPPROD " +
                                            " where i.LOTE_MATERIAL_PROVEEDOR = '"+res.getString("COD_LOTE_PRODUCCION")+"' ";
                                            resDetalle=stDetalle.executeQuery(consulta);
                                            if(resDetalle.next())
                                            {
                                                fechaVencimiento=sdf.format(resDetalle.getTimestamp("FECHA_VENCIMIENTO"));
                                            }
                                            

                                   }
                                   
                                   consulta="select i.FECHA_VENC from INGRESOS_DETALLEVENTAS i where i.COD_LOTE_PRODUCCION='"+res.getString("COD_LOTE_PRODUCCION")+"'" +
                                            " and cast(i.COD_INGRESOVENTAS as varchar)+'-'+cast(i.COD_AREA_EMPRESA as varchar) in"+
                                            " (select cast(iv.COD_INGRESOVENTAS as varchar)+'-'+cast(iv.COD_AREA_EMPRESA as varchar) "+
                                            " from INGRESOS_VENTAS iv where iv.COD_ESTADO_INGRESOVENTAS<>2  and iv.FECHA_INGRESOVENTAS>'2012/01/01 00:00:00' and iv.COD_ALMACEN_VENTA<>32"+
                                            " ) and i.COD_PRESENTACION in (select cpp.COD_PRESENTACION from COMPONENTES_PRESPROD cpp where cpp.COD_COMPPROD='"+res.getString("COD_COMPPROD")+"')";
                                    resDetalle=stDetalle.executeQuery(consulta);
                                    fechaApt="";
                                    while(resDetalle.next())
                                    {
                                        if(fechaApt.equals(""))
                                        {
                                            fechaApt=sdf.format(resDetalle.getTimestamp("FECHA_VENC"));
                                        }
                                        else
                                        {
                                            if(fechaVencimiento.equals(sdf.format(resDetalle.getTime("FECHA_VENC"))))
                                            {
                                                fechaApt=sdf.format(resDetalle.getTime("FECHA_VENC"));
                                            }
                                        }
                                    }
                                   

                                   out.println("<tr><td>"+res.getString("nombre_prod_semiterminado")+"</td>" +
                                              "<td>"+res.getString("COD_LOTE_PRODUCCION")+"</td><td>"+fechaVencimiento+"</td>" +
                                              "<td  "+(fechaVencimiento.equals(fechaAcond)?"":" bgcolor='red'")+" >"+fechaAcond+"</td>" +
                                              "<td "+(fechaVencimiento.equals(fechaApt)?"":" bgcolor='red'")+" >"+fechaApt+"</td>" +
                                              "</tr>");
                               }
                               res.close();
                               st.close();
                               con.close();
                        }
                        catch(SQLException ex)
                        {
                            ex.printStackTrace();
                        }

                        %>
                        </tbody>
                 </table>
             </center>
        </form>
    </body>
</html>
