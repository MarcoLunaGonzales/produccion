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
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
        <style>
            td{
                padding:4px;
                border-bottom:1px solid black;
                border-right:1px solid black;
            }
        </style>
        
    </head>
    <body>
       
        <form>
            
            
            <table width="70%" align="center" class="outputTextNormal" style="border-top:1px solid black;border-left:1px solid black;" cellpadding="0" cellspacing="0" >
            <tr bgcolor="orange" class="outputText2" style="font-weight:bold">
                <td colspan="3" rowspan="2" align="center" >INFORMACION GENERAL</td>
                <td colspan="17" align="center">INFORMACION DEL NUCLEO</td>
                <td colspan="8" align="center">INFORMACION DEL COMPRIMIDO RECUBIERTO</td>
            </tr>
            <tr bgcolor="orange" class="outputText2">
                <td colspan="3" align="center" style="font-weight:bold">ASPECTO</td>
                <td colspan="4" align="center" style="font-weight:bold">DIMENSIONES</td>
                <td colspan="10" align="center" style="font-weight:bold">PARAMETROS FISICOS/QUIMICOS</td>
                <td colspan="8" align="center" style="font-weight:bold">PARAMETROS FISICOQUIMICOS</td>
            </tr>
            <tr bgcolor="orange" class="outputText2" style="font-weight:bold">
                <td>PRODUCTO</td>
                <td>NOMBRE GENERICO/CONCENTRACION</td>
                <td>PRESENTACION PRIMARIA</td>
                <td>FORMA</td>
                <td>IMPRESION LOGO COFAR</td>
                <td>COLOR</td>
                <td>DIAMETRO (mm)</td>
                <td>ESPESOR/ ALTURA (mm)</td>
                <td>LARGO&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (mm)</td>
                <td>ANCHO&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (mm)</td>
                <td>% HUMEDAD DE MEZCLA </td>
                <td>PESO TEORICO (g)</td>
                <td>PESO MAXIMO LIMITE DE ALERTA (g)</td>
                <td>PESO MINIMO LIMITE DE ALERTA (g)</td>
                <td>DUREZA</td>
                <td>FRIABILIDAD</td>
                <td>DESINTEGRACION</td>
                <td>% DE VALORACION</td>
                <td>UNIFORMIDAD DE CONTENIDO</td>
                <td>% DE DISOLUCION</td>
                <td>TIPO DE RECUBRIMIENTO</td>
                <td>COLOR DE COMP. RECUBIERTO</td>
                <td>PESO Max(g) cubierta pelicular</td>
                <td>PESO Min(g) cubierta pelicular</td>
                <td>PESO Max(g) cubierta enterica</td>
                <td>PESO Min(g) cubierta enterica</td>
                <td>TIEMPOS DE DESINTEGRACION(COMPRIMIDO RECUBIERTO)</td>
                <td>DISOLUCION</td>
                </tr>
            <%
            try
            {
                Connection con=null;
                con=Util.openConnection(con);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                String consulta="select p.nombre_prod,cp.cod_forma,cp.COD_COMPPROD,cp.NOMBRE_GENERICO,isnull(ep.nombre_envaseprim,'') as envasePrim,"+
                                " isnull(tpp.ABREVIATURA,'') as ABREVIATURA,"+
                                " isnull(pp.CANTIDAD,0) as CANTIDAD,pp.COD_TIPO_PROGRAMA_PROD"+
                                " from COMPONENTES_PROD cp inner join productos p on p.cod_prod=cp.COD_PROD"+
                                " left outer join PRESENTACIONES_PRIMARIAS pp on  "+
                                " pp.COD_COMPPROD=cp.COD_COMPPROD and pp.COD_ESTADO_REGISTRO=1"+
                                " left outer join ENVASES_PRIMARIOS ep on ep.cod_envaseprim=pp.COD_ENVASEPRIM"+
                                " left outer join TIPOS_PROGRAMA_PRODUCCION tpp on "+
                                " tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                                " where  cp.COD_FORMA in (1,35,36,37,38,39,40)  and cp.COD_ESTADO_COMPPROD=1"+
                                " order by p.nombre_prod";
                ResultSet res=st.executeQuery(consulta);
                String nombreProd="";
                int codComprod=0;
                String nombreGenerico="";
                String presentacionPrimaria="";
                Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet resDetalle=null;
                while(res.next())
                {
                    if(codComprod!=res.getInt("COD_COMPPROD"))
                        {
                            if(codComprod!=0)
                            {
                                    %>
                                    <tr>
                                        <td><span class="outputText2">&nbsp;<%=nombreProd%></span></td>
                                        <td><span class="outputText2">&nbsp;<%=nombreGenerico%></span></td>
                                        <td><span class="outputText2">&nbsp;<%=presentacionPrimaria%></span></td>
                                        <%
                                            consulta="select ef.COD_ESPECIFICACION,isnull(efp.DESCRIPCION,'') as DESCRIPCION,efp.VALOR_EXACTO,ef.unidad,efp.LIMITE_INFERIOR,efp.LIMITE_SUPERIOR" +
                                                    ",ef.unidad,ef.COD_TIPO_RESULTADO_ANALISIS"+
                                                    " from ESPECIFICACIONES_FISICAS_CC ef left outer join ESPECIFICACIONES_FISICAS_PRODUCTO efp"+
                                                    " on ef.COD_ESPECIFICACION=efp.COD_ESPECIFICACION and efp.COD_PRODUCTO='"+codComprod+"'"+
                                                    " where ef.COD_ESPECIFICACION in (16, 30, 36, 9, 35, 32, 33,43, 44,10, 11, 12)"+
                                                    " order by case ef.COD_ESPECIFICACION"+
                                                               " when 16 then 1"+
                                                               " when 30 then 2"+
                                                               " when 36 then 3"+
                                                              "  when 9 then 4"+
                                                              " when 35 then 5"+
                                                              " when 32 then 6"+
                                                              " when 33 then 7"+
                                                              " when 43 then 8"+
                                                              " when 44 then 9"+
                                                              " when 10 then 10"+
                                                              " when 11 then 11"+
                                                              " when 12 then 12"+
                                                              " else 34"+
                                                              " end";
                                            System.out.println("consulta buscar especificaciones "+consulta);
                                            resDetalle=stDetalle.executeQuery(consulta);
                                            String texto="";
                                            int codTipo=0;
                                            int codEspecificacion=0;
                                            double valorExacto=0;
                                            String pesoMaxPeli="No aplica";
                                            String pesoMinPeli="No aplica";
                                            String pesoMaxEnte="No aplica";
                                            String pesoMinEnte="No aplica";
                                            while(resDetalle.next())
                                            {
                                                codEspecificacion=resDetalle.getInt("COD_ESPECIFICACION");
                                                codTipo=resDetalle.getInt("COD_TIPO_RESULTADO_ANALISIS");
                                                texto=(codTipo==1?resDetalle.getString("DESCRIPCION"):
                                                    (codTipo==2?(resDetalle.getDouble("LIMITE_INFERIOR")+"-"+resDetalle.getDouble("LIMITE_SUPERIOR")):""));
                                                if(codEspecificacion!=44)
                                                {
                                                    %>
                                                    <td><span class="outputText2">&nbsp;<%=texto%></span></td>
                                                    <%
                                                }
                                                else
                                                {
                                                   valorExacto=resDetalle.getDouble("VALOR_EXACTO");
                                                    %>
                                                    <td><span class="outputText2">&nbsp;<%=valorExacto%></span></td>
                                                    <td><span class="outputText2">&nbsp;<%=(valorExacto+(valorExacto*0.03))%></span></td>
                                                    <td><span class="outputText2">&nbsp;<%=(valorExacto-(valorExacto*0.03))%></span></td>
                                                    <%
                                                }
                                            }
                                            consulta="select eq.COD_ESPECIFICACION,m.NOMBRE_CCC,eqp.VALOR_EXACTO,"+
                                                     " eqp.LIMITE_INFERIOR,eqp.LIMITE_SUPERIOR,eq.unidad,eq.COEFICIENTE,tr.NOMBRE_REFERENCIACC"+
                                                    " from ESPECIFICACIONES_QUIMICAS_CC eq left outer join"+
                                                    " ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp on eq.COD_ESPECIFICACION=eqp.COD_ESPECIFICACION"+
                                                    " and eqp.ESTADO=1 and eqp.COD_PRODUCTO='"+codComprod+"'"+
                                                    " left outer join MATERIALES m on m.COD_MATERIAL=eqp.COD_MATERIAL" +
                                                    " left outer join TIPOS_REFERENCIACC tr on tr.COD_REFERENCIACC=eqp.COD_REFERENCIA_CC"+
                                                    " where eq.COD_ESPECIFICACION in (2,5,6)"+
                                                    " order by case eq.COD_ESPECIFICACION when 2 then 1 when 5 then 2 when 6 then 3 else 23 end,m.NOMBRE_MATERIAL";
                                            System.out.println("consulta cargar esp quimicas "+consulta);
                                            String valoracion="";
                                            String uniformidadContenido="";
                                            String disolucion="";
                                            resDetalle=stDetalle.executeQuery(consulta);
                                            while(resDetalle.next())
                                            {
                                                valoracion+=((resDetalle.getInt("COD_ESPECIFICACION")==2&&resDetalle.getString("NOMBRE_REFERENCIACC")!=null)?("<tr><td style='border:none;"+(valoracion.equals("")?"":"border-top:1px solid black")+"'><span class='outputText2'>"+resDetalle.getDouble("LIMITE_INFERIOR")+resDetalle.getString("UNIDAD")+"-"+resDetalle.getDouble("LIMITE_SUPERIOR")+resDetalle.getString("UNIDAD")+"<br>"+resDetalle.getString("NOMBRE_CCC")+"<br>("+resDetalle.getString("NOMBRE_REFERENCIACC")+")</span></td></tr>"):"");
                                      uniformidadContenido+=((resDetalle.getInt("COD_ESPECIFICACION")==5&&resDetalle.getString("NOMBRE_REFERENCIACC")!=null)?("<tr><td style='border:none;"+(uniformidadContenido.equals("")?"":"border-top:1px solid black")+"'><span class='outputText2'>"+resDetalle.getString("COEFICIENTE")+"<="+resDetalle.getDouble("VALOR_EXACTO")+"<br> "+resDetalle.getString("NOMBRE_CCC")+"<br>("+resDetalle.getString("NOMBRE_REFERENCIACC")+")</span></td></tr>"):"");
                                                disolucion+=((resDetalle.getInt("COD_ESPECIFICACION")==6&&resDetalle.getString("NOMBRE_REFERENCIACC")!=null)?("<tr><td style='border:none;"+(disolucion.equals("")?"":"border-top:1px solid black")+"'><span class='outputText2'>"+resDetalle.getString("COEFICIENTE")+"<"+resDetalle.getDouble("VALOR_EXACTO")+"<br> "+resDetalle.getString("NOMBRE_CCC")+"<br>("+resDetalle.getString("NOMBRE_REFERENCIACC")+")</span></td></tr>"):"");
                                            }
                                            %>
                                                <td style="padding:0px;"><table width="100%" cellpadding="0" cellspacing="0"><%=(valoracion)%></table></td>
                                                <td style="padding:0px;"><table width="100%" cellpadding="0" cellspacing="0"><%=uniformidadContenido%></table></td>
                                                <td style="padding:0px;"><table width="100%" cellpadding="0" cellspacing="0"><%=disolucion%></table></td>
                                            <%
                                            consulta="select ef.COD_ESPECIFICACION,isnull(efp.DESCRIPCION,'') as DESCRIPCION,efp.VALOR_EXACTO,ef.unidad,efp.LIMITE_INFERIOR,efp.LIMITE_SUPERIOR" +
                                                    ",ef.unidad,ef.COD_TIPO_RESULTADO_ANALISIS"+
                                                    " from ESPECIFICACIONES_FISICAS_CC ef left outer join ESPECIFICACIONES_FISICAS_PRODUCTO efp"+
                                                    " on ef.COD_ESPECIFICACION=efp.COD_ESPECIFICACION and efp.COD_PRODUCTO='"+codComprod+"'"+
                                                    " where ef.COD_ESPECIFICACION in (45,39,34)"+
                                                    " order by case ef.COD_ESPECIFICACION"+
                                                               " when 45 then 1"+
                                                               " when 39 then 2"+
                                                               " when 34 then 3"+
                                                              " else 34"+
                                                              " end";
                                            System.out.println("consulta buscar especificaciones 2"+consulta);
                                            resDetalle=stDetalle.executeQuery(consulta);
                                            while(resDetalle.next())
                                            {
                                                codEspecificacion=resDetalle.getInt("COD_ESPECIFICACION");
                                                codTipo=resDetalle.getInt("COD_TIPO_RESULTADO_ANALISIS");
                                                texto=(codTipo==1?resDetalle.getString("DESCRIPCION"):
                                                    (codTipo==2?(resDetalle.getDouble("LIMITE_INFERIOR")+"-"+resDetalle.getDouble("LIMITE_SUPERIOR")):""));
                                                if(codEspecificacion==45)
                                                {
                                                    if(texto.toLowerCase().trim().equals("pelicular"))
                                                    {
                                                        pesoMaxPeli=String.valueOf(valorExacto+((valorExacto+(valorExacto*0.03))*0.025));
                                                        pesoMinPeli=String.valueOf(valorExacto+((valorExacto-(valorExacto*0.03))*0.02));

                                                    }
                                                    if(texto.toLowerCase().trim().equals("enterica"))
                                                    {
                                                        pesoMaxEnte=String.valueOf(valorExacto+((valorExacto+(valorExacto*0.03))*0.14));
                                                        pesoMinEnte=String.valueOf(valorExacto+((valorExacto-(valorExacto*0.03))*0.12));

                                                    }
                                                }
                                                %>
                                                    <td><span class="outputText2">&nbsp;<%=texto%></span></td>
                                                <%
                                                 if(codEspecificacion==39)
                                                {
                                                     %>
                                                     <td><span class="outputText2">&nbsp;<%=pesoMaxPeli%></span></td>
                                                     <td><span class="outputText2">&nbsp;<%=pesoMinPeli%></span></td>
                                                     <td><span class="outputText2">&nbsp;<%=pesoMaxEnte%></span></td>
                                                     <td><span class="outputText2">&nbsp;<%=pesoMinEnte%></span></td>
                                                     <%
                                                     }
                                            }



                                        %>
                                        <td style="padding:0px;"><table width="100%" cellpadding="0" cellspacing="0"><%=disolucion%></table></td>
                                    </tr>
                                    <%
                            }
                            codComprod=res.getInt("cod_compprod");
                            nombreProd=res.getString("nombre_prod");
                            nombreGenerico=res.getString("NOMBRE_GENERICO");
                            presentacionPrimaria=(res.getInt("COD_TIPO_PROGRAMA_PROD")>0?(res.getString("ABREVIATURA")+":"+res.getString("envasePrim")+" X "+res.getInt("CANTIDAD")+" comp"):"");
                        }
                        else
                        {
                            presentacionPrimaria+="  "+res.getString("ABREVIATURA")+":"+res.getString("envasePrim")+" X "+res.getInt("CANTIDAD")+" comp";
                        }
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
               
                
            


               </table>

        
        </form>
    </body>
</html>