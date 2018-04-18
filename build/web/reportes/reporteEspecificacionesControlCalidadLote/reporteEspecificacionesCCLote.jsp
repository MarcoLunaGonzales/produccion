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
        <style>
                .tablaResultado
                {
                    border-top:1px solid black;
                    border-left:1px solid black;
                    margin-top:12px;
                }
                .tablaResultado td
                {
                    border-right:1px solid black;
                    border-bottom:1px solid black;
                    padding:6px;
                }
                
                .fisica
                {
                    background-color:#90EE90;
                }
                .fisicaCelda
                {
                    background-color:#baf5ba;
                }
                .micro
                {
                    background-color:#D2B48C;
                }
                .microCelda
                {
                    background-color:#ecd4b4;
                }
                .quimica
                {
                    background-color:#AFEEEE;
                }
                .quimicaCelda
                {
                    background-color:#cffafa;
                }
        </style>
        
    </head>
    <body>
        <%
        Connection con=null;
        try{
            String nombreComponenteProd=request.getParameter("nombreComponenteProd");
            String codProgramaProd=request.getParameter("codProgramaProd");
            String nombreProgramaProd=request.getParameter("nombreProgramaProd");
            String codCompProd=request.getParameter("codComprodProducto");
            String codEstadoResultadoAnalisis=request.getParameter("codEstadoProgramaProd");
            String nombreEstadoProgramaProd=request.getParameter("nombreEstadoProgramaProd");

            %>
        <form>
           <h3 style="top:1px" align="center">Reporte Resultados de Especificaciones de Control de Calidad</h3 >
           <center>
               <table style="width:90%" cellpadding="1px;">
                   <tr>
                       <td rowspan="3">
                           <img src="../../img/cofar.png">
                       </td>
                       <td>
                           <span class="outputText2" style="font-weight:bold">Producto</span>
                       </td>
                       <td>
                           <span class="outputText2" style="font-weight:bold">::</span>
                       </td>
                       <td>
                           <span class="outputText2" ><%=(nombreComponenteProd)%></span>
                       </td>
                   </tr>
                   <tr>
                        <td>
                           <span class="outputText2" style="font-weight:bold">Estados Certificados</span>
                       </td>
                       <td>
                           <span class="outputText2" style="font-weight:bold">::</span>
                       </td>
                       <td>
                           <span class="outputText2" ><%=(nombreEstadoProgramaProd)%></span>
                       </td>
                   </tr>
                       <tr>
                           <td>
                               <span class="outputText2" style="font-weight:bold">Programa Produccion</span>
                           </td>
                           <td>
                               <span class="outputText2" style="font-weight:bold">::</span>
                           </td>
                           <td>
                               <span class="outputText2" ><%=(nombreProgramaProd)%></span>
                           </td>
                       </tr>

               </table>
            </center>
            <table  width="100%" align="center" class="tablaResultado"  cellpadding="0" cellspacing="0" >
                 <tr class="">
                     <td  rowspan="4" bgcolor="#f2f2f2"  align="center"><span class="outputText2" style="font-weight:bold;">Lote</span></td>
                       <td rowspan="4" class="#f2f2f2" bgcolor="#f2f2f2"  align="center"><span class="outputText2" style="font-weight:bold;">Estado Certificado<br>Control Calidad</span></td>
                <%
                        List<Double[]> resultados=new ArrayList<Double[]>();
                        String codigosEspecificacionFisicaList = "0";
                        String codigosEspecificacionMicrobiologica = "0";
                        con=Util.openConnection(con);
                        String codTipoResultadoAnalisis="";
                        String nombreTipoResultado="";
                            String nombreEspecificacion="";
                            String unidad="";
                            Double limiteInferior=0d;
                            Double limiteSuperior=0d;
                            String coeficiente="";
                            String simbolo="";
                            Double valorExacto=0d;
                        String cabeceraEspecificacionesFisicas="";
                        String cabeceraEspecificacionesMicro="";
                        String cabeceraMaterialesQuimicas="";
                        String cabeceraEspecificacionesQuimicas="";
                        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        String consulta="select distinct efc.NOMBRE_ESPECIFICACION,efc.COD_TIPO_RESULTADO_ANALISIS"+
                                                " ,efc.COEFICIENTE,efc.UNIDAD,efp.COD_ESPECIFICACION" +
                                        " from ESPECIFICACIONES_FISICAS_PRODUCTO efp"
                                            + " inner join ESPECIFICACIONES_FISICAS_CC efc"
                                            + " on efp.COD_ESPECIFICACION=efc.COD_ESPECIFICACION "
                                        +" where efp.COD_PRODUCTO='"+codCompProd+"' and efp.ESTADO=1"
                                        +" order by efc.NOMBRE_ESPECIFICACION";
                        System.out.println("consulta especificaciones Fisicas "+consulta);
                        ResultSet res=st.executeQuery(consulta);
                        int cont=0;
                        while(res.next())
                        {
                            cabeceraEspecificacionesFisicas+=
                               "<td class='fisica' align='center' colspan='2'><span class='outputText2' style='font-weight:normal'>"+res.getString("NOMBRE_ESPECIFICACION")+"</span></td>";
                            codigosEspecificacionFisicaList+=","+res.getString("COD_ESPECIFICACION");
                        }
                        out.println("<td rowspan='2' colspan='"+((codigosEspecificacionFisicaList.split(",").length-1)*2)+"' class='fisica'  align='center'><span class='outputText2' style='font-weight:bold;'>Especificaciones Fisicas</span></td>");
                         consulta=" select distinct eqcc.COD_ESPECIFICACION,isnull(eqcc.NOMBRE_ESPECIFICACION,'Ninguno') as NOMBRE_ESPECIFICACION,eqcc.COD_TIPO_RESULTADO_ANALISIS,"+
                                            " ISNULL(eqcc.COEFICIENTE, '') as COEFICIENTE,"+
                                            " ISNULL(eqcc.UNIDAD, '') AS unidad,isnull(M.NOMBRE_CCC,'Ninguno') as NOMBRE_CCC" +
                                    " from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp"+
                                            " inner join ESPECIFICACIONES_QUIMICAS_CC eqcc on eqp.COD_ESPECIFICACION = eqcc.COD_ESPECIFICACION "+
                                           " left outer join TIPOS_RESULTADOS_ANALISIS tra on"+
                                           " tra.COD_TIPO_RESULTADO_ANALISIS = eqcc.COD_TIPO_RESULTADO_ANALISIS"+
                                           " left outer join MATERIALES m on m.COD_MATERIAL = eqp.COD_MATERIAL"+
                                           " left outer join MATERIALES_COMPUESTOS_CC mcc on"+
                                           " mcc.COD_MATERIAL_COMPUESTO_CC = eqp.COD_MATERIAL_COMPUESTO_CC"+
                                    " where eqp.COD_PRODUCTO = '"+codCompProd+"' and eqp.ESTADO = 1 "+
                                    " order by 2,6";
                         System.out.println("consulta cargarEspecificaciones quimicas "+consulta);
                          res=st.executeQuery(consulta);
                          cont=0;
                          int contEspecifcaciones=0;
                          int codespecificacionCabecera=0;
                          String nombreEspecificacionCabecera="";
                          while(res.next())
                          {
                              if(codespecificacionCabecera!=res.getInt("COD_ESPECIFICACION"))
                              {
                                  if(codespecificacionCabecera>0)
                                  {
                                      cabeceraEspecificacionesQuimicas+="<td class='quimica' colspan='"+(contEspecifcaciones*2)+"' align='center'><span class='outputText2' style='font-weight:normal'>"+nombreEspecificacionCabecera+"</span></td>";
                                  }
                                   
                                  codespecificacionCabecera=res.getInt("COD_ESPECIFICACION");
                                  nombreEspecificacionCabecera=res.getString("NOMBRE_ESPECIFICACION");
                                  contEspecifcaciones=0;
                              }
                                codTipoResultadoAnalisis=res.getString("COD_TIPO_RESULTADO_ANALISIS");
                                cabeceraMaterialesQuimicas+="<td class='quimica' align='center' colspan='2'><span class='outputText2' style='font-weight:normal'>"+res.getString("NOMBRE_CCC")+"</span></td>";
                                contEspecifcaciones++;
                            cont++;
                          }
                          if(codespecificacionCabecera>0)
                          {
                              cabeceraEspecificacionesQuimicas+="<td class='quimica' colspan='"+(contEspecifcaciones*2)+"' align='center'><span class='outputText2' style='font-weight:normal'>"+nombreEspecificacionCabecera+"</span></td>";
                          }
                         out.println("<td  colspan='"+(cont*2)+"' class='quimica'  align='center'><span class='outputText2' style='font-weight:bold;'>Especificaciones Quimicas</span></td>");
                        consulta = "select  rae.RESULTADO_NUMERICO , isnull(trd.NOMBRE_TIPO_RESULTADO_DESCRIPTIVO,'') as NOMBRE_TIPO_RESULTADO_DESCRIPTIVO,"
                                                + " eqp.LIMITE_INFERIOR,eqp.LIMITE_SUPERIOR,eqp.VALOR_EXACTO,eqp.DESCRIPCION,especificacion.*"
                                        +" FROM (select distinct eqcc.COD_ESPECIFICACION, eqp.COD_MATERIAL,"
                                               +" isnull(eqcc.NOMBRE_ESPECIFICACION, 'Ninguno') as NOMBRE_ESPECIFICACION,"
                                               +" eqcc.COD_TIPO_RESULTADO_ANALISIS,ISNULL(eqcc.COEFICIENTE, '') as COEFICIENTE,ISNULL(eqcc.UNIDAD, '') AS unidad,"
                                               +" isnull(M.NOMBRE_CCC, 'Ninguno') as NOMBRE_CCC,isnull(tra.SIMBOLO,'') as SIMBOLO"
                                        +" from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp"
                                             +" inner join ESPECIFICACIONES_QUIMICAS_CC eqcc on eqp.COD_ESPECIFICACION =eqcc.COD_ESPECIFICACION"
                                             +" left outer join MATERIALES m on m.COD_MATERIAL = eqp.COD_MATERIAL"
                                             +" left outer join TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS = eqcc.COD_TIPO_RESULTADO_ANALISIS"
                                        +" where eqp.COD_PRODUCTO = '"+codCompProd+"'"
                                                + " and eqp.ESTADO = 1"
                                        +" ) AS especificacion"
                                        +" left outer join especificaciones_quimicas_producto eqp on eqp.COD_ESPECIFICACION= especificacion.COD_ESPECIFICACION"
                                                +" and eqp.COD_MATERIAL = especificacion.COD_MATERIAL"
                                                +" and eqp.COD_VERSION = ? "
                                        +" left outer join RESULTADO_ANALISIS_ESPECIFICACIONES_QUIMICAS rae on rae.COD_ESPECIFICACION = especificacion.COD_ESPECIFICACION"
                                                        +" and rae.COD_MATERIAL = especificacion.COD_MATERIAL"
                                                +" and rae.COD_LOTE = ?"
                                        +" left outer join TIPO_RESULTADO_DESCRIPTIVO trd on trd.COD_TIPO_RESULTADO_DESCRIPTIVO = rae.COD_TIPO_RESULTADO_DESCRIPTIVO"
                                        +" order by especificacion.NOMBRE_ESPECIFICACION,especificacion.NOMBRE_CCC";
                        System.out.println("consulta resultado esp quim: "+consulta);
                        PreparedStatement pstEspQuim = con.prepareStatement(consulta);
                        consulta="select distinct em.NOMBRE_ESPECIFICACION,em.UNIDAD,em.COD_ESPECIFICACION"+
                                 " from ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO emp"+
                                 " inner join ESPECIFICACIONES_MICROBIOLOGIA em on emp.COD_ESPECIFICACION=em.COD_ESPECIFICACION"+
                                 " inner join TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS= em.COD_TIPO_RESULTADO_ANALISIS"+
                                 " where emp.COD_COMPROD = '"+codCompProd+"' and emp.ESTADO=1 order by em.NOMBRE_ESPECIFICACION";
                        System.out.println("consulta especificaciones microbiologia "+consulta);
                        res=st.executeQuery(consulta);
                        while(res.next())
                        {
                            cabeceraEspecificacionesMicro+=
                               "<td class='micro' align='center' colspan='2'><span class='outputText2' style='font-weight:normal'>"+res.getString("NOMBRE_ESPECIFICACION")+"</span></td>";
                            codigosEspecificacionMicrobiologica += ","+res.getString("COD_ESPECIFICACION");
                        }
                        out.println("<td rowspan='2'  colspan='"+((codigosEspecificacionMicrobiologica.split(",").length -1)*2)+"' class='micro'  align='center'><span class='outputText2' style='font-weight:bold;'>Especificaciones Microbiologicas</span></td>");
                        
                        out.println("<tr>"+cabeceraEspecificacionesQuimicas+" </tr></tr><tr>"+cabeceraEspecificacionesFisicas+cabeceraMaterialesQuimicas+ cabeceraEspecificacionesMicro);
                        out.println("<tr class='outputTextBold'>");
                        for(int i = 0;i<codigosEspecificacionFisicaList.split(",").length - 1;i++)out.println("<td class='fisica'>Especificación</td><td class='fisica'>Resultado</td>");
                        for(int i = 0 ; i < cont ; i++)out.println("<td class='quimica'>Especificación</td><td class='quimica'>Resultado</td>");
                        for(int i = 0;i<codigosEspecificacionMicrobiologica.split(",").length - 1;i++)out.println("<td class='micro'>Especificación</td><td class='micro'>Resultado</td>");
                        out.println("</tr>");
                        consulta = "select em.COD_TIPO_RESULTADO_ANALISIS,isnull(trd.NOMBRE_TIPO_RESULTADO_DESCRIPTIVO,'') as NOMBRE_TIPO_RESULTADO_DESCRIPTIVO"
                                        +",rae.RESULTADO_NUMERICO,em.UNIDAD,em.COEFICIENTE,tra.SIMBOLO"
                                        +" ,emp.DESCRIPCION,emp.VALOR_EXACTO,emp.LIMITE_INFERIOR,emp.LIMITE_SUPERIOR"
                                +" from ESPECIFICACIONES_MICROBIOLOGIA em"
                                        +" left outer join TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS = em.COD_TIPO_RESULTADO_ANALISIS"
                                        +" left outer join ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO emp on emp.COD_ESPECIFICACION=em.COD_ESPECIFICACION"
                                                +" and emp.COD_VERSION = ?"
                                    +" left outer join RESULTADO_ANALISIS_ESPECIFICACIONES rae on rae.COD_ESPECIFICACION= em.COD_ESPECIFICACION"
                                        +" and rae.COD_TIPO_ANALISIS=3"
                                        +" and rae.COD_LOTE =?"
                                    +" left outer join TIPO_RESULTADO_DESCRIPTIVO trd on"
                                             +" trd.COD_TIPO_RESULTADO_DESCRIPTIVO = rae.COD_TIPO_RESULTADO_DESCRIPTIVO"
                                +" where em.COD_ESPECIFICACION in ("+codigosEspecificacionMicrobiologica+")"
                                +" order by em.NOMBRE_ESPECIFICACION";
                        System.out.println("consulta especificacion micro: "+consulta);
                        PreparedStatement pstEspMicro = con.prepareStatement(consulta);
                %>
                      
               </tr>
               <%
                            consulta="select ra.COD_ANALISIS,ra.COD_LOTE,era.NOMBRE_ESTADO_RESULTADO_ANALISIS,pp.COD_COMPPROD_VERSION"+
                                            " ,ef.COD_TIPO_RESULTADO_ANALISIS,efp.VALOR_EXACTO,efp.LIMITE_INFERIOR,efp.LIMITE_SUPERIOR,ef.COEFICIENTE,tra.SIMBOLO"+
                                            " ,efp.DESCRIPCION,rae.RESULTADO_NUMERICO,isnull(trd.NOMBRE_TIPO_RESULTADO_DESCRIPTIVO,'') as NOMBRE_TIPO_RESULTADO_DESCRIPTIVO,isnull(ef.UNIDAD,'') as UNIDAD,ef.NOMBRE_ESPECIFICACION"+
                                     " from RESULTADO_ANALISIS ra"+
                                            " inner join PROGRAMA_PRODUCCION pp on ra.COD_LOTE=pp.COD_LOTE_PRODUCCION and ra.COD_COMPROD=pp.COD_COMPPROD" +
                                            " inner join ESTADOS_RESULTADO_ANALISIS era on era.COD_ESTADO_RESULTADO_ANALISIS=ra.COD_ESTADO_RESULTADO_ANALISIS"+
                                            " left outer join ESPECIFICACIONES_FISICAS_CC ef on ef.COD_ESPECIFICACION in ("+codigosEspecificacionFisicaList+")"+
                                            " left outer join TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS = ef.COD_TIPO_RESULTADO_ANALISIS"+
                                            " left outer join ESPECIFICACIONES_FISICAS_PRODUCTO efp on efp.COD_ESPECIFICACION = ef.COD_ESPECIFICACION"
                                                    +" and pp.COD_COMPPROD_VERSION = efp.COD_VERSION"+
                                            " left outer join RESULTADO_ANALISIS_ESPECIFICACIONES rae on rae.COD_LOTE = pp.COD_LOTE_PRODUCCION"+
                                                " and rae.COD_TIPO_ANALISIS=1 "+
                                                   " and rae.COD_ESPECIFICACION = efp.COD_ESPECIFICACION"+
                                            " left outer join TIPO_RESULTADO_DESCRIPTIVO trd on trd.COD_TIPO_RESULTADO_DESCRIPTIVO = rae.COD_TIPO_RESULTADO_DESCRIPTIVO"+
                                    " where ra.COD_COMPROD='"+codCompProd+"'";
                            consulta+=(codProgramaProd.equals("")?"": " and  pp.COD_PROGRAMA_PROD in ("+codProgramaProd+")")+
                                     (codEstadoResultadoAnalisis.equals("")?"": " and ra.COD_ESTADO_RESULTADO_ANALISIS in ("+codEstadoResultadoAnalisis+")")+
                                     " group by ra.COD_ANALISIS,ra.COD_LOTE,era.NOMBRE_ESTADO_RESULTADO_ANALISIS,pp.COD_COMPPROD_VERSION,tra.SIMBOLO"+
                                            " ,ef.COD_TIPO_RESULTADO_ANALISIS,efp.VALOR_EXACTO,efp.LIMITE_INFERIOR,efp.LIMITE_SUPERIOR,ef.COEFICIENTE"+
                                            " ,efp.DESCRIPCION,rae.RESULTADO_NUMERICO,trd.NOMBRE_TIPO_RESULTADO_DESCRIPTIVO,ef.UNIDAD,ef.NOMBRE_ESPECIFICACION"+
                                     " order by ra.COD_LOTE,ef.NOMBRE_ESPECIFICACION";
                            System.out.println("consulta cargar lotes "+consulta);
                            res=st.executeQuery(consulta);
                            Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet resDetalle=null;
                            String codLoteCabecera ="";
                            int codVersionCabecera = 0;
                            while(res.next()){
                                if(!codLoteCabecera.equals(res.getString("COD_LOTE"))){
                                    if(codLoteCabecera.length() > 0){
                                        pstEspQuim.setInt(1, codVersionCabecera);
                                        pstEspQuim.setString(2,codLoteCabecera);
                                        resDetalle = pstEspQuim.executeQuery();
                                        while(resDetalle.next())
                                        {
                                            String especificacion = (resDetalle.getInt("COD_TIPO_RESULTADO_ANALISIS") == 1 ? resDetalle.getString("DESCRIPCION"):(resDetalle.getInt("COD_TIPO_RESULTADO_ANALISIS") == 2 ? resDetalle.getDouble("LIMITE_INFERIOR")+" - "+resDetalle.getDouble("LIMITE_SUPERIOR") : resDetalle.getString("COEFICIENTE")+" "+resDetalle.getString("SIMBOLO")+" "+resDetalle.getDouble("VALOR_EXACTO")));
                                            out.println("<td class='quimicaCelda' align='center'>"
                                                            + "<span>"+especificacion+"</span>"
                                                    + "</td>"
                                                    + "<td class='quimicaCelda' align='center'><span class='outputText2'>"
                                                    +( !resDetalle.getString("NOMBRE_TIPO_RESULTADO_DESCRIPTIVO").equals("") ? resDetalle.getString("NOMBRE_TIPO_RESULTADO_DESCRIPTIVO"):resDetalle.getDouble("RESULTADO_NUMERICO")+" "+resDetalle.getString("UNIDAD"))
                                                    +"</span></td>");
                                        }
                                        pstEspMicro.setInt(1,codVersionCabecera);
                                        pstEspMicro.setString(2,codLoteCabecera);
                                        resDetalle = pstEspMicro.executeQuery();
                                         while(resDetalle.next())
                                         {
                                             String especificacion = (resDetalle.getInt("COD_TIPO_RESULTADO_ANALISIS") == 1 ? resDetalle.getString("DESCRIPCION"):(resDetalle.getInt("COD_TIPO_RESULTADO_ANALISIS") == 2 ? resDetalle.getDouble("LIMITE_INFERIOR")+" - "+resDetalle.getDouble("LIMITE_SUPERIOR") : resDetalle.getString("COEFICIENTE")+" "+resDetalle.getString("SIMBOLO")+" "+resDetalle.getDouble("VALOR_EXACTO")));
                                             out.println("<td class='microCelda' align='center'>"
                                                            + "<span>"+especificacion+"</span>"
                                                        + "</td>"
                                                        +"<td class='microCelda' align='center'><span class='outputText2'>"
                                                        +( !resDetalle.getString("NOMBRE_TIPO_RESULTADO_DESCRIPTIVO").equals("") ? resDetalle.getString("NOMBRE_TIPO_RESULTADO_DESCRIPTIVO"):resDetalle.getDouble("RESULTADO_NUMERICO")+" "+resDetalle.getString("UNIDAD"))
                                                        +"</span></td>");
                                         }
                                         out.println("</tr>");
                                    }
                                    out.println("<tr><td  align='center'><span class='outputText2' style='font-weight:bold;'>"+res.getString("COD_LOTE")+"</span></td>" +
                                                "<td align='center'><span class='outputText2'>"+res.getString("NOMBRE_ESTADO_RESULTADO_ANALISIS")+"</span></td>");
                                    codLoteCabecera = res.getString("COD_LOTE");
                                    codVersionCabecera = res.getInt("COD_COMPPROD_VERSION");
                                }
                                String especificacion = (res.getInt("COD_TIPO_RESULTADO_ANALISIS") == 1 ? res.getString("DESCRIPCION"):(res.getInt("COD_TIPO_RESULTADO_ANALISIS") == 2 ? res.getDouble("LIMITE_INFERIOR")+" - "+res.getDouble("LIMITE_SUPERIOR") : res.getString("COEFICIENTE")+" "+res.getString("SIMBOLO")+" "+res.getDouble("VALOR_EXACTO")));
                                out.println("<td class='fisicaCelda' align='center'>"
                                                +"<span>"+especificacion+"</span>"
                                            + "</td>"
                                            + "<td class='fisicaCelda' align='center'>"
                                            +" <span class='outputText2'>"+(!res.getString("NOMBRE_TIPO_RESULTADO_DESCRIPTIVO").equals("") ? res.getString("NOMBRE_TIPO_RESULTADO_DESCRIPTIVO"):res.getDouble("RESULTADO_NUMERICO")+" "+res.getString("UNIDAD"))+"</span></td>");//
                                
                                
                            }
                            if(codLoteCabecera.length() > 0){
                                pstEspQuim.setInt(1, codVersionCabecera);
                                pstEspQuim.setString(2,codLoteCabecera);
                                resDetalle = pstEspQuim.executeQuery();
                                while(resDetalle.next())
                                {
                                    String especificacion = (resDetalle.getInt("COD_TIPO_RESULTADO_ANALISIS") == 1 ? resDetalle.getString("DESCRIPCION"):(resDetalle.getInt("COD_TIPO_RESULTADO_ANALISIS") == 2 ? resDetalle.getDouble("LIMITE_INFERIOR")+" - "+resDetalle.getDouble("LIMITE_SUPERIOR") : resDetalle.getString("COEFICIENTE")+" "+resDetalle.getString("SIMBOLO")+" "+resDetalle.getDouble("VALOR_EXACTO")));
                                    out.println("<td class='quimicaCelda' align='center'>"
                                                    + "<span>"+especificacion+"</span>"
                                            + "</td>"
                                            + "<td class='quimicaCelda' align='center'><span class='outputText2'>"
                                            +( !resDetalle.getString("NOMBRE_TIPO_RESULTADO_DESCRIPTIVO").equals("") ? resDetalle.getString("NOMBRE_TIPO_RESULTADO_DESCRIPTIVO"):resDetalle.getDouble("RESULTADO_NUMERICO")+" "+resDetalle.getString("UNIDAD"))
                                            +"</span></td>");
                                }
                                pstEspMicro.setInt(1,codVersionCabecera);
                                pstEspMicro.setString(2,codLoteCabecera);
                                resDetalle = pstEspMicro.executeQuery();
                                 while(resDetalle.next())
                                 {
                                     String especificacion = (resDetalle.getInt("COD_TIPO_RESULTADO_ANALISIS") == 1 ? resDetalle.getString("DESCRIPCION"):(resDetalle.getInt("COD_TIPO_RESULTADO_ANALISIS") == 2 ? resDetalle.getDouble("LIMITE_INFERIOR")+" - "+resDetalle.getDouble("LIMITE_SUPERIOR") : resDetalle.getString("COEFICIENTE")+" "+resDetalle.getString("SIMBOLO")+" "+resDetalle.getDouble("VALOR_EXACTO")));
                                     out.println("<td class='microCelda' align='center'>"
                                                    + "<span>"+especificacion+"</span>"
                                                + "</td>"
                                                +"<td class='microCelda' align='center'><span class='outputText2'>"
                                                +( !resDetalle.getString("NOMBRE_TIPO_RESULTADO_DESCRIPTIVO").equals("") ? resDetalle.getString("NOMBRE_TIPO_RESULTADO_DESCRIPTIVO"):resDetalle.getDouble("RESULTADO_NUMERICO")+" "+resDetalle.getString("UNIDAD"))
                                                +"</span></td>");
                                 }
                                 out.println("</tr>");
                            }
                            
                    }
                    catch(SQLException ex)
                    {
                        ex.printStackTrace();
                    }

                    catch(Exception ex)
                    {
                        ex.printStackTrace();
                    }

                 %>

               </table>

              
            <br>

            <br>
            <div align="center">
                <%--<INPUT type="button" class="commandButton" name="btn_registrar" value="<-- Atrás" onClick="cancelar();"  >--%>

            </div>
        </form>
    </body>
</html>