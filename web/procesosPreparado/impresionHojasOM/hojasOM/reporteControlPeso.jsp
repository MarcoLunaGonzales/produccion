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
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.GregorianCalendar"%>
<%@ page language="java" import = "org.joda.time.*"%>
<%@ page language="java" import="java.util.*,com.cofar.util.CofarConnection" %>
<html>
   <head>
   <style>
    table
    {
        border-top:1px solid black ;
        border-left:1px solid black;
    }
    table tr th
    {
        border-bottom:1px solid black;
        border-right:1px solid black;
        padding-left:0.5em;
        padding-right:0.5em;
        padding-top:0.3em;
        padding-bottom:0.3em;
    }
    
    .bold
    {
        font-weight:bold;
        font-family: 'Arial';
        font-size:12px;
        font-style:normal;

    }
    .normal
    {
        font-weight:400;
        font-family: 'Arial';
        font-size:12px;
        font-style:normal;

    }
    @media print{
        .pagina{
            border:1px solid black;
            height:100%;
            width:100%;
            border-collapse:collapse;
        }
        table{
            width:100%;
            border:none;
        }
        
        table tr th table
        {
            border-top:1px solid black;
            border-left:1px solid black;
            width:90%;
        }
        .ultCol
        {
            border-right:none;
        }
        .ultFil
        {
            border-bottom:none;
            height:100%;
            vertical-align:super;
        }
    }
    .pagina 
    {
        page-break-inside:auto;
    }
    
</style>
</head>
 <body >
     
<div class="pagina">
    <table width="80%" align="center" class="outputText0"  cellpadding="0" cellspacing="0" >
                 <%
                 String loteAsociado="";
                 int cantAsociado=0;
                 NumberFormat nf1 = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat formato= (DecimalFormat)nf1;
                formato.applyPattern("####.#####");
                int codProgramaProd=Integer.valueOf(request.getParameter("codProgramaProd"));
                String codLoteProduccion=request.getParameter("codLote");
                String fechaVencimiento="";
                int codCompProd=0;
                String nombreProducto="";
                int vidaUtil=0;
                SimpleDateFormat sdf=new SimpleDateFormat("MM-yyyy");
                SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
                SimpleDateFormat sdfHoras=new SimpleDateFormat("HH:mm");
                String nombreEnvasePrimario="";
                String registroSanitario="";
                String nombreFormaFarmaceutica="";
                String tamLote="";
                String abreviaturaForma="";
                String abreviaturaTP="ABREVIATURA";
                String codComprodMix="";
                Double[] prod1=new Double[4];
                Double[] prod2=new Double[3];
                int codForma=0;
                char b=13;char c=10;
                Date fechaCierre=new Date();
                String personalAprueba="";
                int codSeguimiento=0;
                String observacion="";
                int codRecetaDosificado=0;
                  try
                  {
                    Connection con=null;
                    con=Util.openConnection(con);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    String consulta="select pp.cod_formula_maestra,f.cod_forma,pp.COD_FORMULA_MAESTRA,cp.COD_COMPPROD,f.abreviatura_forma,p.nombre_prod,cp.NOMBRE_GENERICO,f.nombre_forma,cp.REG_SANITARIO,"+
                                    " ep.nombre_envaseprim,cp.VIDA_UTIL,pp.CANT_LOTE_PRODUCCION,ppp.FECHA_FINAL,cp.cod_area_empresa" +
                                    " ,cp.PESO_ENVASE_PRIMARIO,tpp.ABREVIATURA as abtp,(cast (cp.CANTIDAD_VOLUMEN as varchar) + ' ' + um.ABREVIATURA) as VOLUMEN_ENVASE_PRIMARIO,fm.CANTIDAD_LOTE,ppm.CANTIDAD,cpm.NOMBRE_COLORPRESPRIMARIA" +
                                    " ,cp.CANTIDAD_VOLUMEN,um.ABREVIATURA,cp.TOLERANCIA_VOLUMEN_FABRICAR,tpp.COD_TIPO_PROGRAMA_PROD,tpp.COD_TIPO_PROGRAMA_PROD" +
                                    ",ISNULL((select top 1 spp.FECHA_INICIO from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp"+
                                    " inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA = spp.COD_ACTIVIDAD_PROGRAMA and"+
                                    "  spp.COD_FORMULA_MAESTRA = afm.COD_FORMULA_MAESTRA where spp.COD_LOTE_PRODUCCION = pp.COD_LOTE_PRODUCCION and afm.COD_ACTIVIDAD = 186"+
                                    "  order by spp.FECHA_FINAL DESC ), (select top 1 spp1.FECHA_INICIO from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp1"+
                                    "  inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA = spp1.COD_ACTIVIDAD_PROGRAMA and"+
                                    "  spp1.COD_FORMULA_MAESTRA = afm.COD_FORMULA_MAESTRA where spp1.COD_LOTE_PRODUCCION = pp.COD_LOTE_PRODUCCION and afm.COD_ACTIVIDAD in (71,48) "+
                                    "  order by spp1.FECHA_FINAL DESC )) as fecha," +
                                    "  ISNULL(dpff.PRE_INDICACIONES_CONTROL_LLENADO_VOLUMEN, '') as PRE_INDICACIONES_CONTROL_LLENADO_VOLUMEN,"+
                                    " isnull(dpff.INDICACIONES_CONTROL_VOLUMEN_LLENADO, '') as INDICACIONES_CONTROL_VOLUMEN_LLENADO"+
                                    " ,scll.COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE,scll.FECHA_CIERRE"+
                                    " ,(per.AP_PATERNO_PERSONAL+' '+per.AP_MATERNO_PERSONAL+' '+per.NOMBRES_PERSONAL+' '+per.nombre2_personal) as nombrePersonal" +
                                    " ,isnull(loteAsociado.loteAsociado,'') as loteAsociado,isnull(loteAsociado.cantAsociado,0) as cantAsociado" +
                                    " ,scll.OBSERVACION,isnull(cpr.COD_RECETA_DOSIFICADO, 0) as COD_RECETA_DOSIFICADO"+
                                    " from PROGRAMA_PRODUCCION pp inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD"+
                                    " inner join FORMAS_FARMACEUTICAS f on f.cod_forma=cp.COD_FORMA"+
                                    " inner join productos p on p.cod_prod=cp.COD_PROD"+
                                    " inner join PRESENTACIONES_PRIMARIAS ppm on ppm.COD_COMPPROD=cp.COD_COMPPROD and ppm.COD_ESTADO_REGISTRO=1 and ppm.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                                    " inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim=ppm.COD_ENVASEPRIM" +
                                    " inner join PROGRAMA_PRODUCCION_PERIODO ppp on pp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD"+
                                    " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD" +
                                    " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA" +
                                    " left outer join COLORES_PRESPRIMARIA cpm on cpm.COD_COLORPRESPRIMARIA=cp.COD_COLORPRESPRIMARIA" +
                                    " left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=cp.COD_UNIDAD_MEDIDA_VOLUMEN" +
                                    " left outer join DESCRIPCION_PROCESOS_FORMA_FARMACEUTICA dpff on dpff.COD_FORMA=cp.COD_FORMA"+
                                    " inner join SEGUIMIENTO_CONTROL_LLENADO_LOTE scll on scll.COD_PROGRAMA_PROD =pp.COD_PROGRAMA_PROD and scll.COD_LOTE = pp.COD_LOTE_PRODUCCION"+
                                    " inner join personal per on per.COD_PERSONAL=scll.COD_PERSONAL_SUPERVISOR" +
                                    " left outer join COMPONENTES_PROD_RECETA cpr on cpr.COD_COMPROD = pp.COD_COMPPROD" +
                                    " outer APPLY(select top 1 lpc.COD_LOTE_PRODUCCION_ASOCIADO as loteAsociado,pp1.CANT_LOTE_PRODUCCION as cantAsociado"+
                                    " from LOTES_PRODUCCION_CONJUNTA lpc inner join PROGRAMA_PRODUCCION pp1 on"+
                                    " lpc.COD_PROGRAMA_PROD=pp1.COD_PROGRAMA_PROD and lpc.COD_LOTE_PRODUCCION_ASOCIADO=pp1.COD_LOTE_PRODUCCION"+
                                    " where lpc.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and lpc.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION"+
                                    " and pp1.COD_COMPPROD=pp.COD_COMPPROD) loteAsociado"+
                                    " where pp.COD_LOTE_PRODUCCION='"+codLoteProduccion+"' and pp.cod_programa_prod='"+codProgramaProd+"'";
                    System.out.println("consulta cargar datos del lote "+consulta);
                    ResultSet res=st.executeQuery(consulta);
                    
                    double tamanoLote=0d;
                    
                    String codFormulaMaestra="";
                    double cantidadVolumenEnvase=0d;
                    double toleranciaVolumen=0d;
                    String codTipoprogramaProd="";
                    String preindicacionesControlDosificado="";
                    String indicacionesControlDosificado="";
                    NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                    DecimalFormat format = (DecimalFormat)nf;
                    format.applyPattern("#,##0.0");
                    if(res.next())
                    {
                        codRecetaDosificado=res.getInt("COD_RECETA_DOSIFICADO");
                        observacion=res.getString("OBSERVACION");
                        codSeguimiento=res.getInt("COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE");
                        fechaCierre=res.getTimestamp("FECHA_CIERRE");
                        personalAprueba=res.getString("nombrePersonal");
                        codCompProd=res.getInt("COD_COMPPROD");
                        loteAsociado=res.getString("loteAsociado");
                        cantAsociado=res.getInt("cantAsociado");
                        vidaUtil=res.getInt("vida_util");
                        preindicacionesControlDosificado=res.getString("PRE_INDICACIONES_CONTROL_LLENADO_VOLUMEN").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>").replace("\"v\"","\"√\"");
                        indicacionesControlDosificado=res.getString("INDICACIONES_CONTROL_VOLUMEN_LLENADO").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>").replace("\"v\"","\"√\"");
                        codTipoprogramaProd=res.getString("COD_TIPO_PROGRAMA_PROD");
                        toleranciaVolumen=res.getDouble("TOLERANCIA_VOLUMEN_FABRICAR");
                        codFormulaMaestra=res.getString("cod_formula_maestra");
                        codComprodMix=res.getString("COD_COMPPROD");
                        prod1[0]=res.getDouble("COD_COMPPROD");
                        prod1[1]=(res.getDouble("CANT_LOTE_PRODUCCION")/res.getDouble("CANTIDAD_LOTE"));
                        tamanoLote=res.getDouble("CANT_LOTE_PRODUCCION");
                        prod1[2]=res.getDouble("COD_FORMULA_MAESTRA");
                        prod1[3]=res.getDouble("CANTIDAD_LOTE");
                        cantidadVolumenEnvase=res.getDouble("CANTIDAD_VOLUMEN");
                        abreviaturaTP=res.getString("abtp");
                        if(res.getDate("fecha")!=null)//FECHA_FINAL
                        {
                            Calendar cal = new GregorianCalendar();
                            cal.setTimeInMillis(res.getDate("fecha").getTime());
                            cal.add(Calendar.MONTH, (vidaUtil+(res.getDate("fecha").getDate()>=27?1:0)));
                            fechaVencimiento =sdf.format(new Date(cal.getTimeInMillis()));
                        }
                        else
                        {
                            if(res.getDate("FECHA_FINAL")!=null)
                            {
                                Calendar cal = new GregorianCalendar();
                                cal.setTimeInMillis(res.getDate("FECHA_FINAL").getTime());
                                cal.add(Calendar.MONTH, (vidaUtil+(res.getDate("FECHA_FINAL").getDate()>=27?1:0)));
                                fechaVencimiento =sdf.format(new Date(cal.getTimeInMillis()));
                            }
                            else
                            {
                                fechaVencimiento="No tiene registrado pesaje";
                            }


                        }
                        if(res.getString("cod_forma").equals("2"))
                        {
                            consulta="select FECHA_VENCIMIENTO from INGRESOS_ALMACEN_DETALLE_ESTADO i inner join FORMULA_MAESTRA_DETALLE_EP fmdep on fmdep.COD_MATERIAL = i.COD_MATERIAL" +
                            " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA = fmdep.COD_FORMULA_MAESTRA inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = fm.COD_COMPPROD " +
                            " where i.LOTE_MATERIAL_PROVEEDOR = '"+codLoteProduccion+"' ";
                            Statement stdetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet resDet=stdetalle.executeQuery(consulta);
                            if(resDet.next())
                            {
                                fechaVencimiento =sdf.format(resDet.getDate("FECHA_VENCIMIENTO"));
                            }
                            else
                            {
                                fechaVencimiento="No existe stock del lote en almacen";
                            }
                            resDet.close();
                            stdetalle.close();
                       }
                            
                            
                            
                            codForma=res.getInt("cod_forma");
                            nombreFormaFarmaceutica=res.getString("nombre_forma");
                            nombreProducto=res.getString("nombre_prod");
                            nombreEnvasePrimario=res.getString("nombre_envaseprim").toLowerCase();
                            
                            
                            nombreEnvasePrimario+=((codForma==2||codForma==14||codForma==33||codForma==16|| codForma==10||codForma==26||codForma==27||codForma==29)?" "+res.getString("NOMBRE_COLORPRESPRIMARIA")+" por "+formato.format(cantidadVolumenEnvase)+" "+res.getString("ABREVIATURA"):
                                                  ((codForma==6||codForma==1||codForma==32||(codForma>=35&&codForma<=41))?" por "+res.getInt("CANTIDAD")+" "+nombreFormaFarmaceutica.toLowerCase():
                                                 ((codForma==7||codForma==25)?" por "+formato.format(cantidadVolumenEnvase)+" "+res.getString("ABREVIATURA"):
                                                 ((codForma==12||codForma==20||codForma==31||codForma==11||codForma==34||codForma==30||codForma==13)?" por "+res.getString("PESO_ENVASE_PRIMARIO"):
                                                  ((codForma==36)?" por "+res.getInt("CANTIDAD")+"comprimidos":"") ))));

                            
                            registroSanitario=res.getString("REG_SANITARIO");
                            tamLote=res.getString("CANT_LOTE_PRODUCCION");
                            abreviaturaForma=res.getString("abreviatura_forma").toLowerCase();
                       }
                       if(res.next())
                       {
                            prod2[0]=res.getDouble("COD_COMPPROD");
                            prod2[1]=(res.getDouble("CANT_LOTE_PRODUCCION")/res.getDouble("CANTIDAD_LOTE"));
                            prod2[2]=res.getDouble("COD_FORMULA_MAESTRA");
                            tamanoLote+=res.getDouble("CANT_LOTE_PRODUCCION");
                            codTipoprogramaProd+=","+res.getString("COD_TIPO_PROGRAMA_PROD");
                           if(!codComprodMix.equals(res.getString("COD_COMPPROD")))
                           {
                               codComprodMix+=","+res.getString("COD_COMPPROD");
                           }
                           nombreEnvasePrimario+=" ("+abreviaturaTP+") y "+res.getString("nombre_envaseprim").toLowerCase();
                            
                            
                            codForma=res.getInt("cod_forma");
                            nombreFormaFarmaceutica=res.getString("nombre_forma");
                            nombreProducto=res.getString("nombre_prod");
                            nombreEnvasePrimario+=((codForma==2||codForma==14||codForma==33||codForma==16|| codForma==10||codForma==26||codForma==27||codForma==29)?" "+res.getString("NOMBRE_COLORPRESPRIMARIA")+" por "+formato.format(cantidadVolumenEnvase)+" "+res.getString("ABREVIATURA"):
                                                  ((codForma==6||codForma==1||codForma==32||(codForma>=35&&codForma<=41))?" por "+res.getInt("CANTIDAD")+" "+nombreFormaFarmaceutica.toLowerCase():
                                                 ((codForma==7||codForma==25)?" por "+formato.format(cantidadVolumenEnvase)+" "+res.getString("ABREVIATURA"):
                                                 ((codForma==12||codForma==20||codForma==31||codForma==11||codForma==34||codForma==30||codForma==13)?" por "+res.getString("PESO_ENVASE_PRIMARIO"):
                                                  ((codForma==36)?" por "+res.getInt("CANTIDAD")+"comprimidos":"") ))))+"("+res.getString("abtp")+")";
                           tamLote+=" "+abreviaturaTP+" - "+res.getString("CANT_LOTE_PRODUCCION")+" "+res.getString("abtp");
                       }

                                           consulta="select m.NOMBRE_CCC,cpc.CANTIDAD,um.ABREVIATURA,cpc.UNIDAD_PRODUCTO" +
                                                    ",cpc.NOMBRE_MATERIAL_EQUIVALENCIA,cpc.CANTIDAD_EQUIVALENCIA,isnull(ume.ABREVIATURA,'') as abreEquivalencia"+
                                                     " from COMPONENTES_PROD_CONCENTRACION cpc inner join materiales m"+
                                                     " on cpc.COD_MATERIAL=m.COD_MATERIAL inner join UNIDADES_MEDIDA um on "+
                                                     " um.COD_UNIDAD_MEDIDA=cpc.COD_UNIDAD_MEDIDA" +
                                                     " left outer join UNIDADES_MEDIDA ume on ume.COD_UNIDAD_MEDIDA=cpc.COD_UNIDAD_MEDIDA_EQUIVALENCIA"+
                                                     " where cpc.COD_ESTADO_REGISTRO=1 and cpc.COD_COMPPROD='"+codCompProd+"'"+
                                                     " order by m.NOMBRE_CCC";
                                            System.out.println("consulta concentracion "+consulta);
                                            res=st.executeQuery(consulta);
                                            String concentracion="";
                                            String porUnidadProd="";
                                            if(res.next())
                                            {
                                                concentracion=res.getString("NOMBRE_CCC")+" "+formato.format(res.getDouble("CANTIDAD"))+" "+res.getString("ABREVIATURA");
                                                concentracion+=(res.getInt("CANTIDAD_EQUIVALENCIA")>0?(" equivalente a "+res.getString("NOMBRE_MATERIAL_EQUIVALENCIA")+" "+formato.format(res.getDouble("CANTIDAD_EQUIVALENCIA"))+" "+res.getString("abreEquivalencia")):"");
                                                porUnidadProd=res.getString("UNIDAD_PRODUCTO");
                                            }
                                            while(res.next())
                                            {
                                                concentracion+=", "+res.getString("NOMBRE_CCC")+" "+formato.format(res.getDouble("CANTIDAD"))+" "+res.getString("ABREVIATURA");//res.getString("datoMaterial");
                                                concentracion+=(res.getInt("CANTIDAD_EQUIVALENCIA")>0?(" equivalente a "+res.getString("NOMBRE_MATERIAL_EQUIVALENCIA")+" "+formato.format(res.getDouble("CANTIDAD_EQUIVALENCIA"))+" "+res.getString("abreEquivalencia")):"");
                                            }
                                            concentracion+=(porUnidadProd.equals("")?"":" / ")+porUnidadProd;
                        consulta=" select rd.VALOR_EXACTO from RECETAS_DESPIROGENIZADO rd where rd.COD_ESPECIFICACION_PROCESO=28 and rd.COD_RECETA='"+codRecetaDosificado+"'";
                        res=st.executeQuery(consulta);
                        Double limiteAceptacion=0d;
                        if(res.next())limiteAceptacion=res.getDouble("VALOR_EXACTO");

                        out.println("<tr ><th colspan='2' rowspan='3'><center><img src='../../../img/cofar.png'></center></th>" +
                                "<th colspan='3' align='center'><span class='bold'><b>FORMULA MAESTRA</b></span></th>" +
                                "<th  align='center'><span class='normal'>Número de Página</span></th>" +
                                "<th  align='center'><input type='text' size='3' value='7' style='text-align:center;border:none;background-color:#ffffff'></th>" +
                                "<th  align='center'><span style='font-weight:normal'>&nbsp;de&nbsp;</span></th>" +
                                "<th  align='center' class='ultCol'><input type='text' size='3' value='10' style='text-align:center;border:none;background-color:#ffffff'></th>" +
                                "</tr>" +
                                "<tr>" +
                                "<th colspan='3'  align='center' rowspan='2'><span class='bold'><b>CONTROL DE PESO</b></span></th>" +
                                "<th  align='left'><span class='normal'>Lote</span></th>" +
                                "<th colspan='3' align='left' class='ultCol'><span class='normal'>"+(codLoteProduccion+(loteAsociado.equals("")?"":"<br>"+loteAsociado))+"</span></th>" +
                                "</tr><tr>" +
                                "<th  align='left'><span class='normal'>Expiración</span></th>" +
                                "<th  align='left' class='ultCol' colspan='3'>"+(fechaVencimiento.split("-").length>1?"<span class='normal'>"+fechaVencimiento+"</span>":"<input style='border:none' type='text' value='"+fechaVencimiento+"'/>")+"</th>" +
                                "</tr><tr>" +
                                "<th class='ultCol' colspan='9'  align='left'>&nbsp;</th>" +
                                "</tr><tr>" +
                                "<th colspan='2' align='left'><span class='normal'>Nombre Comercial</span></th>" +
                                "<th colspan='3' align='center' ><span class='bold'><b>"+nombreProducto+"</b></span></th>" +
                                "<th  align='left'><span class='normal'>Presentación</span></th>" +
                                "<th colspan='3' class='ultCol' align='left'><span class='normal'>"+nombreEnvasePrimario+"</span></th>" +
                                "</tr><tr>" +
                                "<th colspan='2' rowspan='2'  align='left'><span class='normal'>Concentración</span></th>" +
                                "<th colspan='3' rowspan='2'  align='left'><span class='normal'>"+concentracion+"&nbsp;</span></th>" +
                                "<th  align='left'><span class='normal'>N° de Registro Sanitario</span></th>" +
                                "<th colspan='3' class='ultCol' align='left'><span class='normal'>"+registroSanitario+"</span></th>" +
                                "</tr><tr>" +
                                "<th  align='left'><span class='normal'>Vida util del producto</span></th>" +
                                "<th colspan='3' class='ultCol'  align='left'><span class='normal'>"+vidaUtil+" meses</span></th>" +
                                "</tr><tr>" +
                                "<th colspan='2'  align='left'><span class='normal'>Forma Farmaceútica</span></th>" +
                                "<th colspan='3'  align='left'><span class='normal'>"+nombreFormaFarmaceutica+"</span></th>" +
                                "<th  align='left'><span class='normal'>Tamaño de Lote Industrial</span></th>" +
                                "<th colspan='2'   align='left'><span class='normal'>"+tamLote+(loteAsociado.equals("")?"":"<br>"+cantAsociado)+"</span></th>" +
                                "<th align='left' class='ultCol'><span class='normal'>"+abreviaturaForma+"</span></th>" +
                                "</tr><tr><th class='ultCol' colspan='9'>&nbsp;</th></tr>" +
                                
                                "<tr><th bgcolor='#cccccc' colspan='9' align='center' class='ultCol'><span class='bold' style='font-size:12px;'>CONTROL DE PESO</span></th></tr>" +
                                "<tr><th colspan='9' align='left' class='ultCol ultFil'><span class='bold'></span><span class='normal'>"+preindicacionesControlDosificado+"</span>" +
                                "<table  align='center' class='outputText0'  cellpadding='0' cellspacing='0' >");
                        consulta="select tpp.NOMBRE_TIPO_PROGRAMA_PROD,isnull(sclle.LIMITE_TEORICO, 0) as limiteTeorico,"+
                                 " isnull(sclle.LIMITE_INFERIOR, 0) as limiteInferior,isnull(sclle.LIMITE_SUPERIOR, 0) as limiteSuperior"+
                                 " from PROGRAMA_PRODUCCION pp inner join TIPOS_PROGRAMA_PRODUCCION tpp " +
                                 " on tpp.COD_TIPO_PROGRAMA_PROD = pp.COD_TIPO_PROGRAMA_PROD"+
                                 " left outer join SEGUIMIENTO_CONTROL_LLENADO_LOTE_ESP sclle on pp.COD_TIPO_PROGRAMA_PROD = sclle.COD_TIPO_PROGRAMA_PROD and"+
                                 " sclle.COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE = '"+codSeguimiento+"' where pp.COD_LOTE_PRODUCCION = '"+codLoteProduccion+"'" +
                                 " and pp.COD_PROGRAMA_PROD ="+codProgramaProd;
                        System.out.println("consulta limites aceptacion "+consulta);
                        res=st.executeQuery(consulta);
                        while(res.next())
                        {
                            out.println("<tr><th bgcolor='#cccccc' align='center' colspan='6'><span class='bold' >"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+"</span></th></tr>" +
                                        "<tr>" +
                                        "<th><span class='bold' >Limites de aceptación<br>Teórico en gramos</span></th><th><span class='normal'>"+res.getDouble("limiteTeorico")+"</span></th>" +
                                        "<th><span class='bold' >Limites de aceptación<br>Máximo en gramos</span></th><th><span class='normal'>"+res.getDouble("limiteSuperior")+"</span></th>" +
                                        "<th><span class='bold' >Limites de aceptación<br>Mínimo en gramos</span></th><th><span class='normal'>"+res.getDouble("limiteInferior")+"</span></th>" +
                                        "</tr>");
                        }
                        out.println("</table>");
                        String cabeceraPersonal="";
                        String innerCabeceraPersonal="";
                        String detallePersonal="";
                        int contDetalle=0;
                        consulta="select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+'<br>'+p.NOMBRES_PERSONAL)as nombrePersonal"+
                                 " from SEGUIMIENTO_MAQUINARIAS_CONTROL_LLENADO_VOLUMEN s inner join personal p on"+
                                 " p.COD_PERSONAL=s.COD_PERSONAL"+
                                 " where s.COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE='"+codSeguimiento+"'"+
                                 " group by p.COD_PERSONAL,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL"+
                                 " order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL";
                        res=st.executeQuery(consulta);
                        while(res.next())
                        {
                            innerCabeceraPersonal+="<th bgcolor='#cccccc'><span class='bold'>"+res.getString("nombrePersonal")+"</span></th>";
                            cabeceraPersonal+=" ,ISNULL(smaclv"+res.getRow()+".COD_MAQUINA,0) as registrado"+res.getRow();
                            detallePersonal+=" LEFT OUTER JOIN SEGUIMIENTO_MAQUINARIAS_CONTROL_LLENADO_VOLUMEN smaclv"+res.getRow()+" on "+
                                             " smaclv"+res.getRow()+".COD_MAQUINA=m.COD_MAQUINA and "+
                                             " smaclv"+res.getRow()+".COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE = '"+codSeguimiento+"'" +
                                             " and smaclv"+res.getRow()+".COD_PERSONAL='"+res.getInt("COD_PERSONAL")+"'";
                            contDetalle=res.getRow();
                        }
                         
                         out.println(" <table style='margin-top:2em' align='center' class='outputText0'  cellpadding='0' cellspacing='0' >" +
                                     "<tr>"+innerCabeceraPersonal+"<th bgcolor='#cccccc' align='center'><span class='bold' >Maquina Dosificadora</span></th></tr>");
                         consulta="SELECT cpml.COD_MAQUINA,m.NOMBRE_MAQUINA,m.CODIGO" +cabeceraPersonal+
                                 " from COMPONENTES_PROD_MAQUINARIA_LIMPIEZA cpml inner join MAQUINARIAS m "+
                                 " on m.COD_MAQUINA=cpml.COD_MAQUINA" +detallePersonal+
                                 " where cpml.COD_COMPPROD='"+codCompProd+"' and m.COD_SECCION_ORDEN_MANUFACTURA in (3)" +
                                 " order by m.NOMBRE_MAQUINA";
                         res=st.executeQuery(consulta);
                         while(res.next())
                         {
                             out.println("<tr>");
                             for(int i=1;i<=contDetalle;i++)
                             {
                                 out.println("<th><span class='bold'>"+(res.getInt("registrado"+i)>0?"√":"&nbsp;")+"</span></th>");
                             }
                             out.println("<th><span class='normal'>"+res.getString("NOMBRE_MAQUINA")+"</span></th></tr>");
                         }
                        out.println("</table><br><span class='bold'>Frecuencia de muestreo:</span><span class='normal'>"+indicacionesControlDosificado+"</span>");
                        out.println(" <table width='80%' style='margin-top:0.5em' align='center' class='outputText0'  cellpadding='0' cellspacing='0' >" +
                                "<tr><th bgcolor='#cccccc' colspan='8'><span class='bold'>Volumen de Ampollas(1er Turno)</span></th></tr>" +
                                "<tr>" +
                                "<th bgcolor='#cccccc' align='center'><span class='bold'>Hora</span></th>" +
                                "<th bgcolor='#cccccc' align='center'><span class='bold'>Frasco 1</span></th>" +
                                "<th bgcolor='#cccccc' align='center'><span class='bold'>Frasco 2</span></th>" +
                                "<th bgcolor='#cccccc' align='center'><span class='bold'>Frasco 3</span></th>" +
                                "<th bgcolor='#cccccc' align='center'><span class='bold'>Frasco 4</span></th>" +
                                /*"<th bgcolor='#cccccc' align='center'><span class='bold'>Ampolla 5</span></th>" +
                                "<th bgcolor='#cccccc' align='center'><span class='bold'>Ampolla 6</span></th>" +*/
                                "<th bgcolor='#cccccc' align='center'><span class='bold'>Operario</span></th>" +
                                "</tr>"
                                );
                        if(!loteAsociado.equals(""))tamanoLote+=cantAsociado;
                        consulta="SELECT sclld.HORA_MUESTRA,ISNULL(sclld.VOLUMEN_AMPOLLA1,0) as VOLUMEN_AMPOLLA1,"+
                                 " ISNULL(sclld.VOLUMEN_AMPOLLA2,0) as VOLUMEN_AMPOLLA2,ISNULL(sclld.VOLUMEN_AMPOLLA3,0) as VOLUMEN_AMPOLLA3,"+
                                 " ISNULL(sclld.VOLUMEN_AMPOLLA4,0) as VOLUMEN_AMPOLLA4,ISNULL(sclld.VOLUMEN_AMPOLLA5,0) as VOLUMEN_AMPOLLA5,"+
                                 " ISNULL(sclld.VOLUMEN_AMPOLLA6,0) as VOLUMEN_AMPOLLA6" +
                                 ",isnull(sclld.COD_PERSONAL,0) as COD_PERSONAL" +
                                 " ,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL) as nombrePersonal"+
                                 " FROM SEGUIMIENTO_CONTROL_LLENADO_LOTE_DETALLE sclld" +
                                 " inner join personal p on p.COD_PERSONAL=sclld.COD_PERSONAL"+
                                 " where sclld.COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE='"+codSeguimiento+"'"+
                                 " and sclld.TURNO=1"+
                                 " order by sclld.HORA_MUESTRA";
                        System.out.println("consulta detalle primerTurno "+consulta);
                        res=st.executeQuery(consulta);
                        while(res.next())
                        {
                            out.println("<tr>" +
                                        "<th><span class='normal'>"+sdfHoras.format(res.getTimestamp("HORA_MUESTRA"))+"</span></th>" +
                                        "<th><span class='normal'>"+format.format(res.getDouble("VOLUMEN_AMPOLLA1"))+"</span></th>"+
                                        "<th><span class='normal'>"+format.format(res.getDouble("VOLUMEN_AMPOLLA2"))+"</span></th>"+
                                        "<th><span class='normal'>"+format.format(res.getDouble("VOLUMEN_AMPOLLA3"))+"</span></th>"+
                                        "<th><span class='normal'>"+format.format(res.getDouble("VOLUMEN_AMPOLLA4"))+"</span></th>"+
                                        /*"<th><span class='normal'>"+format.format(res.getDouble("VOLUMEN_AMPOLLA5"))+"</span></th>"+
                                        "<th><span class='normal'>"+format.format(res.getDouble("VOLUMEN_AMPOLLA6"))+"</span></th>"+*/
                                        "<th><span class='normal'>"+res.getString("nombrePersonal")+"</span></th>"+
                                        "</tr>");
                            

                        }
                        out.println("</table></th></tr></table></div><div class='pagina'>" +
                                "<table width='80%' align='center' class='outputText0'  cellpadding='0' cellspacing='0' ><tr>" +
                                "<th  align='left' class='ultFil ultCol'> <table width='80%' style='margin-top:0.5em' align='center' class='outputText0'  cellpadding='0' cellspacing='0' >" +
                                "<tr><th bgcolor='#cccccc'  colspan='8'><span class='bold'>Volumen de Ampollas(2do Turno)</span></th></tr>" +
                                "<tr>" +
                                "<th bgcolor='#cccccc' align='center'><span class='bold'>Hora</span></th>" +
                                "<th bgcolor='#cccccc' align='center'><span class='bold'>Frasco 1</span></th>" +
                                "<th bgcolor='#cccccc' align='center'><span class='bold'>Frasco 2</span></th>" +
                                "<th bgcolor='#cccccc' align='center'><span class='bold'>Frasco 3</span></th>" +
                                "<th bgcolor='#cccccc' align='center'><span class='bold'>Frasco 4</span></th>" +
                                /*"<th bgcolor='#cccccc' align='center'><span class='bold'>Ampolla 5</span></th>" +
                                "<th bgcolor='#cccccc' align='center'><span class='bold'>Ampolla 6</span></th>" +*/
                                "<th bgcolor='#cccccc' align='center'><span class='bold'>Operario</span></th>" +
                                "</tr>"
                                );
                     consulta="SELECT sclld.HORA_MUESTRA,ISNULL(sclld.VOLUMEN_AMPOLLA1,0) as VOLUMEN_AMPOLLA1,"+
                                 " ISNULL(sclld.VOLUMEN_AMPOLLA2,0) as VOLUMEN_AMPOLLA2,ISNULL(sclld.VOLUMEN_AMPOLLA3,0) as VOLUMEN_AMPOLLA3,"+
                                 " ISNULL(sclld.VOLUMEN_AMPOLLA4,0) as VOLUMEN_AMPOLLA4,ISNULL(sclld.VOLUMEN_AMPOLLA5,0) as VOLUMEN_AMPOLLA5,"+
                                 " ISNULL(sclld.VOLUMEN_AMPOLLA6,0) as VOLUMEN_AMPOLLA6" +
                                 ",isnull(sclld.COD_PERSONAL,0) as COD_PERSONAL" +
                                 " ,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL) as nombrePersonal"+
                                 " FROM SEGUIMIENTO_CONTROL_LLENADO_LOTE_DETALLE sclld" +
                                 " inner join personal p on p.COD_PERSONAL=sclld.COD_PERSONAL"+
                                 " where sclld.COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE='"+codSeguimiento+"'"+
                                 " and sclld.TURNO=2"+
                                 " order by sclld.HORA_MUESTRA";
                    System.out.println("consulta detalle primerTurno "+consulta);
                    res=st.executeQuery(consulta);
                     while(res.next())
                    {
                        out.println("<tr>" +
                                    "<th><span class='normal'>"+sdfHoras.format(res.getTimestamp("HORA_MUESTRA"))+"</span></th>" +
                                    "<th><span class='normal'>"+format.format(res.getDouble("VOLUMEN_AMPOLLA1"))+"</span></th>"+
                                    "<th><span class='normal'>"+format.format(res.getDouble("VOLUMEN_AMPOLLA2"))+"</span></th>"+
                                    "<th><span class='normal'>"+format.format(res.getDouble("VOLUMEN_AMPOLLA3"))+"</span></th>"+
                                    "<th><span class='normal'>"+format.format(res.getDouble("VOLUMEN_AMPOLLA4"))+"</span></th>"+
                                    /*"<th><span class='normal'>"+format.format(res.getDouble("VOLUMEN_AMPOLLA5"))+"</span></th>"+
                                    "<th><span class='normal'>"+format.format(res.getDouble("VOLUMEN_AMPOLLA6"))+"</span></th>"+*/
                                    "<th><span class='normal'>"+res.getString("nombrePersonal")+"</span></th>"+
                                    "</tr>");


                    }
                    out.println("</table>" +
                                "<table width='80%' style='margin-top:0.5em' align='center' class='outputText0'  cellpadding='0' cellspacing='0' >" +
                                "<tr><th bgcolor='#cccccc' colspan='8'><span class='bold'>Volumen de Ampollas(3er Turno)</span></th></tr>" +
                                "<tr>" +
                                "<th bgcolor='#cccccc' align='center'><span class='bold'>Hora</span></th>" +
                                "<th bgcolor='#cccccc' align='center'><span class='bold'>Frasco 1</span></th>" +
                                "<th bgcolor='#cccccc' align='center'><span class='bold'>Frasco 2</span></th>" +
                                "<th bgcolor='#cccccc' align='center'><span class='bold'>Frasco 3</span></th>" +
                                "<th bgcolor='#cccccc' align='center'><span class='bold'>Frasco 4</span></th>" +
                                /*"<th bgcolor='#cccccc' align='center'><span class='bold'>Ampolla 5</span></th>" +
                                "<th bgcolor='#cccccc' align='center'><span class='bold'>Ampolla 6</span></th>" +*/
                                "<th bgcolor='#cccccc' align='center'><span class='bold'>Operario</span></th>" +
                                "</tr>"
                                );
                     consulta="SELECT sclld.HORA_MUESTRA,ISNULL(sclld.VOLUMEN_AMPOLLA1,0) as VOLUMEN_AMPOLLA1,"+
                                 " ISNULL(sclld.VOLUMEN_AMPOLLA2,0) as VOLUMEN_AMPOLLA2,ISNULL(sclld.VOLUMEN_AMPOLLA3,0) as VOLUMEN_AMPOLLA3,"+
                                 " ISNULL(sclld.VOLUMEN_AMPOLLA4,0) as VOLUMEN_AMPOLLA4,ISNULL(sclld.VOLUMEN_AMPOLLA5,0) as VOLUMEN_AMPOLLA5,"+
                                 " ISNULL(sclld.VOLUMEN_AMPOLLA6,0) as VOLUMEN_AMPOLLA6" +
                                 ",isnull(sclld.COD_PERSONAL,0) as COD_PERSONAL" +
                                 " ,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL) as nombrePersonal"+
                                 " FROM SEGUIMIENTO_CONTROL_LLENADO_LOTE_DETALLE sclld" +
                                 " inner join personal p on p.COD_PERSONAL=sclld.COD_PERSONAL"+
                                 " where sclld.COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE='"+codSeguimiento+"'"+
                                 " and sclld.TURNO=3"+
                                 " order by sclld.HORA_MUESTRA";
                    System.out.println("consulta detalle primerTurno "+consulta);
                    res=st.executeQuery(consulta);
                     while(res.next())
                    {
                        out.println("<tr>" +
                                    "<th><span class='normal'>"+sdfHoras.format(res.getTimestamp("HORA_MUESTRA"))+"</span></th>" +
                                    "<th><span class='normal'>"+format.format(res.getDouble("VOLUMEN_AMPOLLA1"))+"</span></th>"+
                                    "<th><span class='normal'>"+format.format(res.getDouble("VOLUMEN_AMPOLLA2"))+"</span></th>"+
                                    "<th><span class='normal'>"+format.format(res.getDouble("VOLUMEN_AMPOLLA3"))+"</span></th>"+
                                    "<th><span class='normal'>"+format.format(res.getDouble("VOLUMEN_AMPOLLA4"))+"</span></th>"+
                                    /*"<th><span class='normal'>"+format.format(res.getDouble("VOLUMEN_AMPOLLA5"))+"</span></th>"+
                                    "<th><span class='normal'>"+format.format(res.getDouble("VOLUMEN_AMPOLLA6"))+"</span></th>"+*/
                                    "<th><span class='normal'>"+res.getString("nombrePersonal")+"</span></th>"+
                                    "</tr>");


                    }
                     out.println("</table");
                     out.println("<br><br><span class='bold'>NOMBRE DEL SUPERVISOR:&nbsp;&nbsp;&nbsp;</span><span class='normal'>"+personalAprueba+"</span>" +
                                "<br><span class='bold'>Fecha:&nbsp;&nbsp;&nbsp;</span><span class='normal'>"+sdfDias.format(fechaCierre)+" </span>" +
                                "<br><br><span class='bold'>OBSERVACIONES:&nbsp;&nbsp;&nbsp;</span><br><span class='normal'>"+observacion+"</span>" +
                                "<br><br><br><br><br><br>" +
                                "</th></tr>");
                        res.close();
                        con.close();
                    
                    }catch(SQLException ex)
                    {
                        ex.printStackTrace();
                    }
                %>
                
            </table>

        
</div>

    </body>
</html>
