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
       <META content="IE=8" http-equiv="X-UA-Compatible">
       <script type="text/javascript" src="joint.all.min.js"></script>
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
        page-break-after:always;
        page-break-before:always;
        
    }
    
</style>
</head>
 <body >
     <center><div id="diagrama" style="left:0px;top:0px;display:block;"></div></center>
<div class="pagina" >
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
                String personalDespeje="";
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
                                    "  isnull(dpff.CONDICIONES_GENERALES_REPESADA,'') as CONDICIONES_GENERALES_REPESADA"+
                                    " ,isnull(sppl.FECHA_CIERRE,getdate()) as FECHA_CIERRE"+
                                    " ,(per.AP_PATERNO_PERSONAL+' '+per.AP_MATERNO_PERSONAL+' '+per.NOMBRES_PERSONAL+' '+per.nombre2_personal) as nombrePersonal" +
                                    ", (per1.AP_PATERNO_PERSONAL + ' ' + per1.AP_MATERNO_PERSONAL + ' ' +per1.NOMBRES_PERSONAL + ' ' + per1.nombre2_personal) as personalDespeje"+
                                    " ,isnull(loteAsociado.loteAsociado,'') as loteAsociado,isnull(loteAsociado.cantAsociado,0) as cantAsociado" +
                                    " ,sppl.OBSERVACION"+
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
                                    " inner join SEGUIMIENTO_PREPARADO_LOTE sppl on sppl.COD_PROGRAMA_PROD="+
                                    " pp.COD_PROGRAMA_PROD and sppl.COD_LOTE= pp.COD_LOTE_PRODUCCION"+
                                    " left outer join personal per on per.COD_PERSONAL = sppl.COD_PERSONAL_SUPERVISOR"+
                                    " left outer join PERSONAL per1 on per1.COD_PERSONAL=sppl.COD_PERSONAL_APRUEBA_DESPEJE"+
                                    
                                    " outer APPLY(select top 1 lpc.COD_LOTE_PRODUCCION_ASOCIADO as loteAsociado,pp1.CANT_LOTE_PRODUCCION as cantAsociado"+
                                    " from LOTES_PRODUCCION_CONJUNTA lpc inner join PROGRAMA_PRODUCCION pp1 on"+
                                    " lpc.COD_PROGRAMA_PROD=pp1.COD_PROGRAMA_PROD and lpc.COD_LOTE_PRODUCCION_ASOCIADO=pp1.COD_LOTE_PRODUCCION"+
                                    " where lpc.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and lpc.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION"+
                                    " and pp1.COD_COMPPROD=pp.COD_COMPPROD) loteAsociado"+
                                    " where pp.COD_LOTE_PRODUCCION='"+codLoteProduccion+"' and pp.cod_programa_prod='"+codProgramaProd+"' order by tpp.COD_TIPO_PROGRAMA_PROD,ppp.FECHA_FINAL desc";
                    System.out.println("consulta cargar datos del lote "+consulta);
                    ResultSet res=st.executeQuery(consulta);
                    
                    double tamanoLote=0d;
                    
                    String codFormulaMaestra="";
                    double cantidadVolumenEnvase=0d;
                    double toleranciaVolumen=0d;
                    String codTipoprogramaProd="";
                    String indicacionesRepesada="";
                    NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                    DecimalFormat format = (DecimalFormat)nf;
                    format.applyPattern("#,##0.0");
                    if(res.next())
                    {
                        personalDespeje=res.getString("personalDespeje");
                        observacion=res.getString("OBSERVACION");
                        personalDespeje=res.getString("personalDespeje");
                        fechaCierre=res.getTimestamp("FECHA_CIERRE");
                        personalAprueba=res.getString("nombrePersonal");
                        codCompProd=res.getInt("COD_COMPPROD");
                        loteAsociado=res.getString("loteAsociado");
                        cantAsociado=res.getInt("cantAsociado");
                        vidaUtil=res.getInt("vida_util");
                        indicacionesRepesada=res.getString("CONDICIONES_GENERALES_REPESADA").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>").replace("\"v\"","\"√\"");
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
                            //codTipoprogramaProd+=","+res.getString("COD_TIPO_PROGRAMA_PROD");
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


                        out.println("<tr ><th colspan='2' rowspan='3'><center><img src='../../../img/cofar.png'></center></th>" +
                                "<th colspan='3' align='center'><span class='bold'><b>FORMULA MAESTRA</b></span></th>" +
                                "<th  align='center'><span class='normal'>Número de Página</span></th>" +
                                "<th  align='center'><input type='text' size='3' value='"+(request.getParameter("codForma").equals("2")?"5":"4")+"' style='text-align:center;border:none;background-color:#ffffff'></th>" +
                                "<th  align='center'><span style='font-weight:normal'>&nbsp;de&nbsp;</span></th>" +
                                "<th  align='center' class='ultCol'><input type='text' size='3' value='10' style='text-align:center;border:none;background-color:#ffffff'></th>" +
                                "</tr>" +
                                "<tr>" +
                                "<th colspan='3'  align='center' rowspan='2'><span class='bold'><b>PROCESO DE PREPARACIÓN</b></span></th>" +
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
                                "<tr><th bgcolor='#cccccc' colspan='9' align='center' class='ultCol'><span class='bold' style='font-size:12px;'>DESPEJE DE LINEA DE PREPARADO</span></th></tr>" +
                                "<tr><th colspan='9' align='left' class='ultCol'><span class='normal'>Realizar segun POE PRO-LES-IN-017 \"DESPEJE DE LINEA DE PREPARADO\"</span><br>" +
                                "<span class='normal'>Realizar el despeje de linea y solicitar al Jefe de area la aprobacion de la seccion de trabajo.</span>" +
                                "<br><br><span class='bold'>Aprobado por:</span><span class='normal'>"+personalDespeje+"</span></th></tr>" +
                                "<tr><th bgcolor='#cccccc' colspan='9' align='center' class='ultCol'><span class='bold' style='font-size:12px;'>PROCESO DE PREPARACION</span></th></tr>" +
                                "<tr><th colspan='9' align='left' class='ultCol ultFil'>"+
                                " <table width='80%' style='margin-top:2em' align='center' class='outputText0'  cellpadding='0' cellspacing='0' >" +
                                "<tr><th bgcolor='#cccccc' colspan='5' align='center'><span class='bold'>Proceso de Preparado</span></th></tr>" +
                                "<tr><th bgcolor='#cccccc' colspan='5' align='center'><span class='bold'>Tiempo de Personal</span></th></tr>");
                                
                               
                        if(!loteAsociado.equals(""))tamanoLote+=cantAsociado;
                        consulta="select af.COD_ACTIVIDAD_FORMULA, spp.COD_MAQUINA, spp.HORAS_MAQUINA, m.NOMBRE_MAQUINA"+
                                 " from ACTIVIDADES_FORMULA_MAESTRA af left outer join SEGUIMIENTO_PROGRAMA_PRODUCCION spp on"+
                                 " spp.COD_ACTIVIDAD_PROGRAMA = af.COD_ACTIVIDAD_FORMULA and spp.COD_LOTE_PRODUCCION = '"+codLoteProduccion+"'" +
                                 " and spp.COD_PROGRAMA_PROD = '"+codProgramaProd+"' and spp.COD_FORMULA_MAESTRA = af.COD_FORMULA_MAESTRA" +
                                 " and spp.COD_TIPO_PROGRAMA_PROD = '"+codTipoprogramaProd+"' and spp.COD_COMPPROD = '"+codCompProd+"'"+
                                 " left outer join MAQUINARIAS m on m.COD_MAQUINA=spp.COD_MAQUINA"+
                                 " where af.COD_ACTIVIDAD = 71 and af.COD_AREA_EMPRESA = 96 and af.cod_presentacion = 0" +
                                 " and af.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"'";
                        System.out.println("consulta detalle cabecera personal "+consulta);
                        res=st.executeQuery(consulta);
                        int codActividadPreparado=0;
                        if(res.next())
                        {
                            codActividadPreparado=res.getInt("COD_ACTIVIDAD_FORMULA");
                            out.println("<tr>" +
                                        "<th   align='left' style='border-right:none'><span class='bold'>Maquinaria:</span></th>" +
                                        "<th align='left' style='border-right:none' colspan='2'><span class='normal'>"+res.getString("NOMBRE_MAQUINA")+"</span></th>" +
                                        "<th   align='left' style='border-right:none' ><span class='bold'>Horas Máquina:</span></th>" +
                                        "<th align='left'><span class='normal'>"+res.getDouble("HORAS_MAQUINA")+"</span></th>" +
                                        "</tr>");
                        }
                        out.println( "<tr><th bgcolor='#cccccc'  align='center'><span class='bold'>Personal</span></th>" +
                                "<th bgcolor='#cccccc'  align='center'><span class='bold'>Fecha</span></th>" +
                                "<th bgcolor='#cccccc'  align='center'><span class='bold'>Hora<br>Inicio</span></th>" +
                                "<th bgcolor='#cccccc'  align='center'><span class='bold'>Hora<br>Final</span></th>" +
                                "<th bgcolor='#cccccc'  align='center'><span class='bold'>Horas<br>Hombre</span></th>" +
                                "</tr>"
                                );
                        consulta="select sppp.COD_PERSONAL,sppp.FECHA_INICIO,sppp.FECHA_FINAL,sppp.HORAS_HOMBRE"+
                                 " ,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombrePersonal"+
                                 " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp inner join personal p on p.COD_PERSONAL=sppp.COD_PERSONAL"+
                                 " where sppp.COD_PROGRAMA_PROD = '"+codProgramaProd+"' and sppp.COD_LOTE_PRODUCCION = '"+codLoteProduccion+"'" +
                                 " and sppp.COD_COMPPROD = '"+codCompProd+"' and sppp.COD_ACTIVIDAD_PROGRAMA = '"+codActividadPreparado+"'" +
                                 " and sppp.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"' and sppp.COD_TIPO_PROGRAMA_PROD = '"+codTipoprogramaProd+"'"+
                                 " order by sppp.FECHA_INICIO";
                        System.out.println("consulta documentacion "+consulta);
                        res=st.executeQuery(consulta);
                        Double sumaHoras=0d;
                        while(res.next())
                        {
                            out.println("<tr>" +
                                        "<th><span class='normal'>"+res.getString("nombrePersonal")+"</span></th>" +
                                        "<th><span class='normal'>"+sdfDias.format(res.getTimestamp("FECHA_INICIO"))+"</span></th>" +
                                        "<th><span class='normal'>"+sdfHoras.format(res.getTimestamp("FECHA_INICIO"))+"</span></th>" +
                                        "<th><span class='normal'>"+sdfHoras.format(res.getTimestamp("FECHA_FINAL"))+"</span></th>" +
                                        "<th><span class='normal'>"+res.getDouble("HORAS_HOMBRE")+"</span></th>" +
                                        "</tr>");
                            sumaHoras+=res.getDouble("HORAS_HOMBRE");

                        }
                         out.println("<tr>" +
                                        "<th align ='right' colspan='4'><span class='bold'>Total:</span></th>" +
                                        "<th><span class='bold'>"+sumaHoras+"</span></th>" +
                                        "</tr>");
                        out.println("</table>"+
                                "<br><br><span class='bold'>NOMBRE DEL SUPERVISOR:&nbsp;&nbsp;&nbsp;</span><span class='normal'>"+personalAprueba+"</span>" +
                                "<br><span class='bold'>Fecha:&nbsp;&nbsp;&nbsp;</span><span class='normal'>"+sdfDias.format(fechaCierre)+" </span>" +
                                "<br><br><span class='bold'>OBSERVACIONES:&nbsp;&nbsp;&nbsp;</span><br><span class='normal'>"+observacion+"</span>" +
                                "<br><br><br><br><br><br>" +
                                "</th></tr>");
                        %>
    </table>
</div>


<input type="hidden" value="120" id="tamTexto"/>

<script type="text/javascript">
            asignarCabecera();
            var uml = Joint.dia.uml;
            var fd=Joint.point;

            <%
                boolean loteMix=false;
                loteMix=codComprodMix.split(",").length>1;
                System.out.println("prod1 "+prod1[1]);
                if(loteMix)
                {
                    consulta="select case when cpm.NRO_COMPPROD_DIAGRAMA_PREPARADO=1 then"+
                             " cpm.COD_COMPROD1 else cpm.COD_COMPROD2 end as codDiagrama"+
                             " from COMPONENTES_PROD_MIX cpm where cpm.COD_COMPROD_MIX='"+codCompProd+"'";
                    System.out.println("consulta codComprodMix "+consulta);
                    res=st.executeQuery(consulta);
                    if(res.next())
                    {
                        codCompProd=res.getInt("codDiagrama");
                    }
                    System.out.println("prodt1"+prod1[0]);
                    if(codCompProd!=prod1[0])
                    {
                        Double[] aux= new Double[3];
                       aux[0]=prod1[0];
                       aux[1]=prod1[1];
                       aux[2]=prod1[2];
                       prod1[0]=prod2[0];
                       prod1[1]=prod2[1];
                       prod1[2]=prod2[2];
                       prod2[0]=aux[0];
                       prod2[1]=aux[1];
                       prod2[2]=aux[2];
                    }
                    System.out.println("prod   "+prod1[0]);
                }

                    b=13;c=10;
                     consulta="select pp.COD_PROCESO_PRODUCTO,pp.OPERARIO_TIEMPO_COMPLETO,pp.descripcion,pp.TIEMPO_PROCESO,pp.COD_PROCESO_PRODUCTO,pp.NRO_PASO,ap.NOMBRE_ACTIVIDAD_PREPARADO," +
                            " pp.TIEMPO_PROCESO_PERSONAL,pp.PORCIENTO_TOLERANCIA_TIEMPO_PROCESO,"+
                            " (p1.AP_PATERNO_PERSONAL+' '+p1.AP_MATERNO_PERSONAL+' '+p1.NOMBRES_PERSONAL) as personal1,"+
                            " isnull((p2.AP_PATERNO_PERSONAL+' '+p2.AP_MATERNO_PERSONAL+' '+p2.NOMBRES_PERSONAL),'') as personal2"+
                            ",isnull(sppl.CONFORME,0) AS CONFORME" +
                            " ,isnull(sppl.OBSERVACIONES,'') as OBSERVACIONES"+
                            " from PROCESOS_PRODUCTO pp inner join ACTIVIDADES_PREPARADO ap on "+
                            " ap.COD_ACTIVIDAD_PREPARADO=pp.COD_ACTIVIDAD_PREPARADO "+
                            "  left outer JOIN maquinarias m on m.COD_MAQUINA=pp.COD_MAQUINA"+
                            " left outer join SEGUIMIENTO_PROCESOS_PREPARADO_LOTE sppl on sppl.COD_PROCESO_PRODUCTO="+
                             " pp.COD_PROCESO_PRODUCTO and sppl.COD_SUB_PROCESO_PRODUCTO=0"+
                             " and sppl.COD_LOTE='"+codLoteProduccion+"' "+
                             " left outer join PERSONAL p1 on p1.COD_PERSONAL=sppl.COD_PERSONAL"+
                            " left outer join PERSONAL p2 on p2.COD_PERSONAL=sppl.COD_PERSONAL2"+
                            " where pp.COD_COMPPROD="+codCompProd+" order by pp.NRO_PASO";
                    System.out.println("consulta procesos prod "+consulta);
                    res=st.executeQuery(consulta);
                    String codProceso="";
                    String codSubProceso="";
                    String codProcesoDestino="";
                    int posYcen=10;
                    int posYder=10;
                    int posYizq=10;
                    int posSubProceso=0;
                    Statement std=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet resd=null;
                    String codProcesoProd="";
                    String codSubProcesoProd="";
                    String especificaciones="";
                    String espEquipSubProces="";
                    String nodos="";
                    int cont2=0;
                    int contNodoP=0;
                    int contNodoSubP=0;
                    int nroPasoProceso=0;
                    int nroPasoSubProceso=0;
                    boolean subprocesoDer=true;
                    boolean primerRegistro=false;
                    Statement stdd=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet resdd=null;
                    String script="";
                    String scriptUnion="";
                    String materiales="";
                    String materialesSubProceso="";
                    double tiempoProceso=0;
                    double tiempoSubProces=0;
                    String descripcion="";
                    String descripcionSubProces="";
                    String maquinariasDetalles="";
                    String cabecera="";
                    String cabeceraSubProces="";
                    String maquinariasSubProces="";
                    
                    DecimalFormat formatoNumero = (DecimalFormat)nf;
                    formatoNumero.applyPattern("###0.0");
                    int operarioTiempoCompletoProcesos=0;
                    int operarioTiempoCompletoSubProceso=0;
                    String variables="";
                    List<String[]> listaPuntos=new ArrayList();
                    String[] puntos=new String[3];
                    puntos[0]="";
                    puntos[1]="";
                    puntos[2]="";
                    String[] subPuntos=new String[3];
                    subPuntos[0]="";
                    subPuntos[1]="";
                    subPuntos[2]="";
                    String personalProceso1="";
                    String personalProceso2="";
                    int conformeProceso=0;
                    String observacionProceso="";
                    String personalSubProceso1="";
                    String personalSubProceso2="";
                    int conformeSubProceso=0;
                    String observacionSubProceso="";
                    while(res.next())
                    {
                        cont2++;
                        contNodoP++;
                        observacionProceso=res.getString("OBSERVACIONES");
                        conformeProceso=res.getInt("CONFORME");
                        personalProceso1=res.getString("personal1");
                        personalProceso2=res.getString("personal2");
                        codProceso=res.getString("COD_PROCESO_PRODUCTO");
                        operarioTiempoCompletoProcesos=res.getInt("OPERARIO_TIEMPO_COMPLETO");
                        nroPasoProceso=res.getInt("NRO_PASO");
                        codProcesoProd=res.getString("COD_PROCESO_PRODUCTO");
                        tiempoProceso=res.getInt("TIEMPO_PROCESO");
                        descripcion=res.getString("descripcion");
                        especificaciones="";

                        if(!codProcesoDestino.equals(""))
                        {
                            subPuntos[1]="s"+codProcesoDestino;
                            subPuntos[2]="1";
                            listaPuntos.add(subPuntos);
                        }
                        else
                        {
                            if((subPuntos[0].length()>0) && (subPuntos[0].charAt(0)=='p'))
                            {
                                subPuntos[1]="s"+codProcesoProd;
                                subPuntos[2]="2";
                                listaPuntos.add(subPuntos);
                            }
                        }

                        if(!puntos[0].equals(""))
                        {
                            System.out.println("ccccccccc "+codProcesoProd);
                            puntos[1]="s"+codProcesoProd;
                            puntos[2]="";
                            listaPuntos.add(puntos);
                        }

                        subPuntos=new String[3];
                        subPuntos[0]="s"+codProcesoProd;
                        subPuntos[1]="";
                        subPuntos[2]="";
                        puntos=new String[3];
                        puntos[0]="s"+codProcesoProd;
                        puntos[1]="";
                        puntos[2]="";
                        codProcesoDestino="";
                        posYcen=posYizq>posYcen?posYizq:posYcen;
                        posSubProceso=0;

                        consulta="select ppeq.COD_ESPECIFICACION_EQUIPO_AMBIENTE,m.NOMBRE_MAQUINA,m.codigo,isnull(eea.NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE,'') as NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE,"+
                                " ISNULL(case WHEN td.COD_TIPO_DESCRIPCION = 1 THEN (case when ppeq.DATOS_NO_CONSOLIDADOS=0 then ppeq.VALOR_DESCRIPTIVO else '_______________' end )"+
                                " WHEN td.COD_TIPO_DESCRIPCION = 2 THEN (case when ppeq.DATOS_NO_CONSOLIDADOS=0 then CAST (ppeq.RANGO_INFERIOR"+
                                " as varchar) + ' - ' + cast (ppeq.RANGO_SUPERIOR as varchar) else '____-_____' end)"+
                                " else (case when ppeq.DATOS_NO_CONSOLIDADOS=0 then CAST (ppeq.VALOR_EXACTO as varchar)else '_____' end )"+
                                " end, '') as resultado,"+
                                " (case WHEN eea.COD_UNIDAD_MEDIDA>0 THEN um.ABREVIATURA"+
                                " WHEN eea.COD_UNIDAD_TIEMPO>0 THEN ut.ABREVIATURA "+
                                " WHEN eea.COD_UNIDAD_VELOCIDAD >0 then  uv.NOMBRE_UNIDAD_VELOCIDAD" +
                                " when eea.COD_UNIDAD_MEDIDA_TEMPERATURA>0 then umt.ABREVIATURA"+
                                " else '4'  end ) as unidad,ppeq.PORCIENTO_TOLERANCIA,(eea.TOLERANCIA*ppeq.VALOR_EXACTO) AS TOLERANCIA" +
                                " ,eea.TOLERANCIA as toleranciaEspecificacion"+
                                " from PROCESOS_PRODUCTO_MAQUINARIA ppm inner join maquinarias m on "+
                                " m.COD_MAQUINA=ppm.COD_MAQUINA left outer join "+
                                " PROCESOS_PRODUCTO_ESP_EQUIP ppeq on"+
                                " ppm.COD_MAQUINA=ppeq.COD_MAQUINA and ppm.COD_PROCESO_PRODUCTO=ppeq.COD_PROCESO_PRODUCTO  and ppeq.COD_FORMULA_MAESTRA='"+(Math.round(prod1[2]))+"'" +//loteMix?Math.round(prod2[2]):
                                " left outer join ESPECIFICACIONES_EQUIPO_AMBIENTE eea on"+
                                " eea.COD_ESPECIFICACION_EQUIPO_AMBIENTE=ppeq.COD_ESPECIFICACION_EQUIPO_AMBIENTE left outer join"+
                                " TIPOS_DESCRIPCION td on td.COD_TIPO_DESCRIPCION=eea.COD_TIPO_DESCRIPCION"+
                                " LEFT OUTER JOIN UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=eea.COD_UNIDAD_MEDIDA"+
                                " left outer join UNIDADES_TIEMPO ut on ut.COD_UNIDAD_TIEMPO=eea.COD_UNIDAD_TIEMPO"+
                                " left outer join UNIDADES_VELOCIDAD_MAQUINARIA uv on uv.COD_UNIDAD_VELOCIDAD=eea.COD_UNIDAD_VELOCIDAD" +
                                " left outer join UNIDADES_MEDIDA_TEMPERATURA umt on "+
                                " umt.COD_UNIDAD_MEDIDA_TEMPERATURA=eea.COD_UNIDAD_MEDIDA_TEMPERATURA"+
                                " where ppm.COD_PROCESO_PRODUCTO='"+codProcesoProd+"' order by m.NOMBRE_MAQUINA,m.codigo,NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE";

                        System.out.println("consulta esp "+consulta);
                        resd=std.executeQuery(consulta);
                        int cont=tiempoProceso>0?7:5;
                        cabecera="";
                        maquinariasDetalles="";
                        String nombreMaq="";
                        String resultado="";
                        System.out.println("hola"+prod1[0]+"cdcd "+prod1[2]+"cdcd");
                        while(resd.next())
                        {
                            nombreMaq=resd.getString("NOMBRE_MAQUINA")+" "+resd.getString("codigo");
                            cont++;
                           if(!cabecera.equals(nombreMaq))
                           {
                               maquinariasDetalles+= cabecera.equals("")?"":((maquinariasDetalles.equals("")?"":",")+"['"+cabecera+"',["+especificaciones+"]]");
                               cabecera=nombreMaq;
                               especificaciones="";
                           }
                            if(!resd.getString("NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE").equals(""))
                             {
                                resultado=resd.getString("resultado");
                                double cant=0d;
                                if(resd.getInt("COD_ESPECIFICACION_EQUIPO_AMBIENTE")==10)
                                {
                                    Statement stMat=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                    ResultSet resMat=stMat.executeQuery("select SUM(fd.CANTIDAD/(case when fd.COD_UNIDAD_MEDIDA = 7 then 1000 else 1 end)) as cantMat from FORMULA_MAESTRA_DETALLE_MP fd where fd.COD_FORMULA_MAESTRA ='"+(Math.round(prod1[2]))+"'");
                                    System.out.println("consulta cantida fm select SUM(fd.CANTIDAD/(case when fd.COD_UNIDAD_MEDIDA = 7 then 1000 else 1 end)) as cantMat from FORMULA_MAESTRA_DETALLE_MP fd where fd.COD_FORMULA_MAESTRA ='"+(Math.round(prod1[2]))+"'");

                                    System.out.println("c "+prod1[1]+" d "+prod2[1] );
                                    if(resMat.next())
                                    {
                                        cant=(loteMix?(resMat.getDouble("cantMat")*prod1[1]):resMat.getDouble("cantMat"));

                                    }
                                    if(loteMix)
                                    {
                                        resMat=stMat.executeQuery("select SUM(fd.CANTIDAD/(case when fd.COD_UNIDAD_MEDIDA = 7 then 1000 else 1 end)) as cantMat from FORMULA_MAESTRA_DETALLE_MP fd where fd.COD_FORMULA_MAESTRA ='"+(Math.round(prod2[2]))+"'");
                                        System.out.println("consulta cantidad fm 2 select SUM(fd.CANTIDAD/(case when fd.COD_UNIDAD_MEDIDA = 7 then 1000 else 1 end)) as cantMat from FORMULA_MAESTRA_DETALLE_MP fd where fd.COD_FORMULA_MAESTRA ='"+(Math.round(prod2[2]))+"'");
                                        if(resMat.next())
                                        {
                                            cant+=(resMat.getDouble("cantMat")*prod2[1]);
                                        }
                                    }
                                    resMat.close();
                                    stMat.close();
                                    resultado=formatoNumero.format(cant);
                                }

                            especificaciones+=((especificaciones.equals("")?"":",")+"'"+resd.getString("NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE")+"','"+
                                    resultado+" "+resd.getString("unidad")+" "+(resd.getDouble("TOLERANCIA")>0||cant>0?(" ±"+formatoNumero.format((cant>0?(cant*resd.getDouble("toleranciaEspecificacion")):resd.getDouble("TOLERANCIA")))+" "+resd.getString("unidad")):"")+"'");

                            }
                        }
                        maquinariasDetalles+= cabecera.equals("")?"":((maquinariasDetalles.equals("")?"":",")+"['"+cabecera+"',["+especificaciones+"]]");
                        consulta="select m.NOMBRE_MATERIAL,ppem.CANTIDAD,um.ABREVIATURA,fmd.CANTIDAD as cantidadfm," +// as porcenta,ppem.PORCIENTO_MATERIAL,fmd.CANTIDAD
                                " ISNULL(fmd1.CANTIDAD,0) as cantidadSegundoMaterial"+
                                 " from PROCESOS_PRODUCTO_ESP_MAT ppem " +
                                 " inner join MATERIALES m on m.COD_MATERIAL=ppem.COD_MATERIAL"+
                                 " inner join FORMULA_MAESTRA_DETALLE_MP fmd on fmd.COD_MATERIAL=ppem.COD_MATERIAL "+
                                 " and fmd.COD_FORMULA_MAESTRA=ppem.COD_FORMULA_MAESTRA"+
                                 " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=fmd.COD_UNIDAD_MEDIDA" +
                                 " left outer join FORMULA_MAESTRA_DETALLE_MP fmd1 on"+
                                 " fmd1.COD_MATERIAL=ppem.COD_MATERIAL and fmd1.COD_FORMULA_MAESTRA='"+(loteMix?Math.round(prod2[2]):0)+"'" +
                                 " where ppem.COD_PROCESO_PRODUCTO='"+codProcesoProd+"'" +
                                 " and ppem.COD_FORMULA_MAESTRA='"+(Math.round(prod1[2]))+"'";//loteMix?Math.round(prod2[2]):
                        consulta="SELECT m.NOMBRE_MATERIAL,um.ABREVIATURA,fmd.cantidad,sum(fmdf.cantidad) as cantidadFraccion,"+
                                 " fmd.CANTIDAD AS cantidadfm,ISNULL(fmd1.CANTIDAD, 0) AS cantidadSegundoMaterial " +
                                 " FROM PROCESOS_PRODUCTO_ESP_MAT ppem INNER JOIN MATERIALES m ON m.COD_MATERIAL = ppem.COD_MATERIAL"+
                                 " INNER JOIN FORMULA_MAESTRA_DETALLE_MP fmd ON fmd.COD_MATERIAL = ppem.COD_MATERIAL"+
                                 " AND fmd.COD_FORMULA_MAESTRA = ppem.COD_FORMULA_MAESTRA"+
                                 " inner join FORMULA_MAESTRA_DETALLE_MP_FRACCIONES fmdf on fmd.COD_FORMULA_MAESTRA=fmdf.COD_FORMULA_MAESTRA"+
                                 " and fmd.COD_MATERIAL=fmdf.COD_MATERIAL and fmdf.COD_FORMULA_MAESTRA_FRACCIONES=ppem.COD_FORMULA_MAESTRA_FRACCIONES"+
                                 " INNER JOIN UNIDADES_MEDIDA um ON um.COD_UNIDAD_MEDIDA = fmd.COD_UNIDAD_MEDIDA"+
                                 " LEFT OUTER JOIN FORMULA_MAESTRA_DETALLE_MP fmd1 ON fmd1.COD_MATERIAL = ppem.COD_MATERIAL"+
                                 " AND fmd1.COD_FORMULA_MAESTRA = '"+(loteMix?Math.round(prod2[2]):0)+"'"+
                                 " WHERE ppem.COD_PROCESO_PRODUCTO = '"+codProcesoProd+"' AND ppem.COD_FORMULA_MAESTRA = '"+(Math.round(prod1[2]))+"'"+
                                 " group by  m.NOMBRE_MATERIAL,um.ABREVIATURA,fmd.cantidad,fmd.CANTIDAD ,fmd1.CANTIDAD";
                                System.out.println("consulta materiales "+consulta);
                                resd=std.executeQuery(consulta);
                                materiales="";
                                double porciento=0d;
                                while(resd.next())
                                {
                                    cont++;
                                    porciento=(loteMix?(resd.getDouble("cantidadFraccion")/resd.getDouble("cantidadfm")):0);
                                    materiales+=((materiales.equals("")?"":",")+"'"+resd.getString("NOMBRE_MATERIAL")+"','"+
                                            nf.format(loteMix?((resd.getDouble("cantidadFraccion")*prod1[1])+(resd.getDouble("cantidadSegundoMaterial")*prod2[1]*porciento)):(resd.getDouble("cantidadFraccion")*prod1[1]))+
                                            //nf.format((resd.getDouble("CANTIDAD")*resd.getDouble("PORCIENTO_MATERIAL")*prod1[1])+(prod2[2]==null?0:((resd.getDouble("cantidadSegundoMaterial")*resd.getDouble("PORCIENTO_MATERIAL")*prod2[1]))))+
                                            " ("+resd.getString("ABREVIATURA")+")'");
                                }
                        consulta="select spp.COD_PROCESO_PRODUCTO_DESTINO,spp.COD_SUB_PROCESO_PRODUCTO,spp.descripcion,spp.TIEMPO_SUB_PROCESO,spp.COD_SUB_PROCESO_PRODUCTO,ap.NOMBRE_ACTIVIDAD_PREPARADO,spp.NRO_PASO,"+
                                 " spp.TIEMPO_SUB_PROCESO_PERSONAL,spp.PORCIENTO_TOLERANCIA_TIEMPO_SUB_PROCESO,spp.OPERARIO_TIEMPO_COMPLETO" +
                                 " ,isnull((p1.AP_PATERNO_PERSONAL+' '+p1.AP_MATERNO_PERSONAL+' '+p1.NOMBRES_PERSONAL),'') as personal1"+
                                 " ,isnull((p2.AP_PATERNO_PERSONAL+' '+p2.AP_MATERNO_PERSONAL+' '+p2.NOMBRES_PERSONAL),'') as personal2"+
                                 " ,sppl.CONFORME,sppl.OBSERVACIONES"+
                                 " from SUB_PROCESOS_PRODUCTO spp inner join ACTIVIDADES_PREPARADO ap"+
                                 " on spp.COD_ACTIVIDAD_PREPARADO=ap.COD_ACTIVIDAD_PREPARADO"+
                                 " left outer join maquinarias m on m.COD_MAQUINA=spp.COD_MAQUINA"+
                                 " left outer join SEGUIMIENTO_PROCESOS_PREPARADO_LOTE sppl on "+
                                 " sppl.COD_PROCESO_PRODUCTO=spp.COD_PROCESO_PRODUCTO and "+
                                 " sppl.COD_SUB_PROCESO_PRODUCTO=spp.COD_SUB_PROCESO_PRODUCTO and sppl.COD_LOTE='"+codLoteProduccion+"'"+
                                 " left outer join PERSONAL p1 on p1.COD_PERSONAL=sppl.COD_PERSONAL"+
                                 " left outer join PERSONAL p2 on p2.COD_PERSONAL=sppl.COD_PERSONAL2"+
                                 " where spp.COD_PROCESO_PRODUCTO='"+codProcesoProd+"'"+
                                 " order by spp.NRO_PASO";
                        System.out.println("consulta subprocesos "+consulta);
                        resd=std.executeQuery(consulta);
                        contNodoSubP=0;
                        primerRegistro=true;
                        subprocesoDer=true;
                        System.out.println("per "+personalProceso1);
                         script+="var s"+codProcesoProd+" = uml.State.create({rect: {x:750, y: "+posYcen+", width: 400, height:"+(cont+(descripcion.equals("")?0:6))*18+"},"+
                                "label: '"+nroPasoProceso+"-Actividad:"+res.getString("NOMBRE_ACTIVIDAD_PREPARADO")+( tiempoProceso>0?"-Tiempo:"+tiempoProceso+
                                " min-Tolerancia:"+nf.format((res.getDouble("PORCIENTO_TOLERANCIA_TIEMPO_PROCESO")/100)*tiempoProceso)+" min":"")+" -Operario Tiempo Completo:"+(operarioTiempoCompletoProcesos>0?"SI":"NO")+
                                "',attrs: {fill:'90-#000-"+(operarioTiempoCompletoProcesos>0?"#87CEFA":"#FFC0CB")+":1-#fff'}," +
                                (materiales.equals("")?"":"materiales:["+materiales+"],")+
                                (maquinariasDetalles.equals("")?"":("datosMaq:["+maquinariasDetalles+"],"))+
                                "operario:'"+personalProceso1+"',"+
                                "personal1:'"+personalProceso1+"',"+
                                "personal2:'"+personalProceso2+"',"+
                                "conforme:'"+conformeProceso+"'," +
                                "observacion:'"+observacionProceso+"',"+
                                "actions:{actividad:null," +
                                "Maquinaria:'ninguno'"+
                                (especificaciones.equals("")?"":",inner: ["+especificaciones+"]") +
                                "},descripcion:'"+descripcion.replace(b, '-').replace(c,' ')+"'" +
                                ",detailsOffsetY:"+(tiempoProceso>0?"5":"3")+",codProcesos:'"+codProceso+"',codSubProceso:'0'});";

                        variables+=(variables.equals("")?"":",")+"s"+codProcesoProd;
                        posYcen+=((cont+(descripcion.equals("")?0:6))*17)+50;
                        while(resd.next())
                            {
                                cont2++;
                                personalSubProceso1=resd.getString("personal1");
                                personalSubProceso2=resd.getString("personal2");
                                conformeSubProceso=resd.getInt("CONFORME");
                                observacionSubProceso=resd.getString("OBSERVACIONES");
                                codProcesoDestino=(resd.getInt("COD_PROCESO_PRODUCTO_DESTINO")>0?resd.getString("COD_PROCESO_PRODUCTO_DESTINO"):"");
                                codSubProceso=resd.getString("COD_SUB_PROCESO_PRODUCTO");
                                operarioTiempoCompletoSubProceso=resd.getInt("OPERARIO_TIEMPO_COMPLETO");
                                descripcionSubProces=resd.getString("descripcion");
                                tiempoSubProces=resd.getDouble("TIEMPO_SUB_PROCESO");
                                nroPasoSubProceso=resd.getInt("NRO_PASO");
                                codSubProcesoProd=resd.getString("COD_SUB_PROCESO_PRODUCTO");
                                subPuntos[1]="p"+codProcesoProd+"s"+codSubProceso;
                                if(subPuntos[0].charAt(0)=='s')
                                {
                                    subPuntos[2]="5";
                                }
                                listaPuntos.add(subPuntos);
                                subPuntos=new String[3];
                                subPuntos[0]="p"+codProcesoProd+"s"+codSubProceso;
                                subPuntos[1]="";
                                subPuntos[2]="";
                                espEquipSubProces="";
                                if(primerRegistro)
                                {
                                    subprocesoDer=!subprocesoDer;
                                    posYcen=(subprocesoDer?(posYder>posYcen?posYder+12:posYcen):(posYizq>posYcen?posYizq+12:posYcen));
                                    posYizq=(subprocesoDer?posYizq:(posYcen>posYizq?posYcen:posYizq));
                                    posYder=(subprocesoDer?(posYcen>posYder?posYcen:posYder):posYder);

                                }
                                contNodoSubP++;
                                consulta="select sppeq.COD_ESPECIFICACION_EQUIPO_AMBIENTE,m.NOMBRE_MAQUINA,ISNULL(m.CODIGO,'') as cod1,isnull(eea.NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE,'') as NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE," +
                                        " ISNULL(case WHEN td.COD_TIPO_DESCRIPCION = 1 THEN (case when sppeq.DATOS_NO_CONSOLIDADOS=0 then sppeq.VALOR_DESCRIPTIVO else '__________' end)"+
                                        " WHEN td.COD_TIPO_DESCRIPCION = 2 THEN (case when sppeq.DATOS_NO_CONSOLIDADOS=0 then (CAST ("+
                                        " sppeq.RANGO_INFERIOR as varchar) + ' - ' + cast ( sppeq.RANGO_SUPERIOR as varchar)) ELSE '___-___' end )"+
                                        " else  (case when sppeq.DATOS_NO_CONSOLIDADOS=0 then CAST (sppeq.VALOR_EXACTO as varchar)else '___' end )"+
                                        " end, '') as resultado,"+
                                         " (case WHEN eea.COD_UNIDAD_MEDIDA > 0 THEN um.ABREVIATURA WHEN eea.COD_UNIDAD_TIEMPO > 0 THEN ut.ABREVIATURA"+
                                         " WHEN eea.COD_UNIDAD_VELOCIDAD > 0 then uv.NOMBRE_UNIDAD_VELOCIDAD " +
                                         " WHEN eea.COD_UNIDAD_MEDIDA_TEMPERATURA>0 then umt.ABREVIATURA else ' ' end) as unidad," +
                                         " (eea.TOLERANCIA*sppeq.VALOR_EXACTO) AS tolerancia"+
                                         " from SUB_PROCESOS_PRODUCTO_MAQUINARIA sppm inner join maquinarias m on"+
                                         " sppm.COD_MAQUINA=m.COD_MAQUINA left outer join SUB_PROCESOS_PRODUCTO_ESP_EQUIP sppeq " +
                                         " on sppeq.COD_MAQUINA=sppm.COD_MAQUINA and sppeq.COD_SUB_PROCESO_PRODUCTO=sppm.COD_SUB_PROCESO_PRODUCTO"+
                                         " and sppeq.COD_PROCESO_PRODUCTO=sppm.COD_PROCESO_PRODUCTO and sppeq.COD_FORMULA_MAESTRA='"+(Math.round(prod1[2]))+"'" +
                                         " left outer join ESPECIFICACIONES_EQUIPO_AMBIENTE eea"+
                                         " on eea.COD_ESPECIFICACION_EQUIPO_AMBIENTE=sppeq.COD_ESPECIFICACION_EQUIPO_AMBIENTE"+
                                         " left outer join TIPOS_DESCRIPCION td on td.COD_TIPO_DESCRIPCION =eea.COD_TIPO_DESCRIPCION"+
                                         " left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=eea.COD_UNIDAD_MEDIDA" +
                                         " left outer join UNIDADES_TIEMPO ut on ut.COD_UNIDAD_TIEMPO=eea.COD_UNIDAD_TIEMPO"+
                                         " left outer join UNIDADES_VELOCIDAD_MAQUINARIA uv on uv.COD_UNIDAD_VELOCIDAD=eea.COD_UNIDAD_VELOCIDAD" +
                                         " left outer join UNIDADES_MEDIDA_TEMPERATURA umt on umt.COD_UNIDAD_MEDIDA_TEMPERATURA=eea.COD_UNIDAD_MEDIDA_TEMPERATURA"+
                                         " where sppm.COD_PROCESO_PRODUCTO='"+codProcesoProd+"'  and sppm.COD_SUB_PROCESO_PRODUCTO='"+codSubProcesoProd+"'"+
                                         " order by m.NOMBRE_MAQUINA,eea.NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE";
                                        System.out.println("consulta buscar det esp equip"+consulta);
                                         resdd=stdd.executeQuery(consulta);

                                         int contSubproces=tiempoSubProces>0?7:5;
                                         cabeceraSubProces="";
                                         maquinariasSubProces="";
                                         String maqSubProcess="";
                                         espEquipSubProces="";
                                         while(resdd.next())
                                         {
                                             maqSubProcess=resdd.getString("NOMBRE_MAQUINA")+" "+resdd.getString("cod1");
                                             if(!cabeceraSubProces.equals(maqSubProcess))
                                               {
                                                   maquinariasSubProces+=cabeceraSubProces.equals("")?"":((maquinariasSubProces.equals("")?"":",")+"['"+cabeceraSubProces+"',["+espEquipSubProces+"]]");
                                                   cabeceraSubProces=maqSubProcess;
                                                   espEquipSubProces="";
                                                   contSubproces++;
                                               }
                                             if(!resdd.getString("NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE").equals(""))
                                             {
                                                 String resultado2=resdd.getString("resultado");
                                                 if(resdd.getInt("COD_ESPECIFICACION_EQUIPO_AMBIENTE")==10)
                                                    {
                                                        Statement stMat=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                                        ResultSet resMat=stMat.executeQuery("select SUM(fd.CANTIDAD/(case when fd.COD_UNIDAD_MEDIDA = 7 then 1000 else 1 end)) as cantMat from FORMULA_MAESTRA_DETALLE_MP fd where fd.COD_FORMULA_MAESTRA ='"+(Math.round(prod1[2]))+"'");
                                                        System.out.println("consulta cantida fm select SUM(fd.CANTIDAD/(case when fd.COD_UNIDAD_MEDIDA = 7 then 1000 else 1 end)) as cantMat from FORMULA_MAESTRA_DETALLE_MP fd where fd.COD_FORMULA_MAESTRA ='"+(Math.round(prod1[2]))+"'");
                                                        double cant=0d;
                                                        System.out.println("c "+prod1[1]+" d "+prod2[1] );
                                                        if(resMat.next())
                                                        {
                                                            cant=(loteMix?(resMat.getDouble("cantMat")*prod1[1]):resMat.getDouble("cantMat"));
                                                        }
                                                        if(loteMix)
                                                        {
                                                            resMat=stMat.executeQuery("select SUM(fd.CANTIDAD/(case when fd.COD_UNIDAD_MEDIDA = 7 then 1000 else 1 end)) as cantMat from FORMULA_MAESTRA_DETALLE_MP fd where fd.COD_FORMULA_MAESTRA ='"+(Math.round(prod2[2]))+"'");
                                                            System.out.println("consulta cantidad fm 2 select SUM(fd.CANTIDAD/(case when fd.COD_UNIDAD_MEDIDA = 7 then 1000 else 1 end)) as cantMat from FORMULA_MAESTRA_DETALLE_MP fd where fd.COD_FORMULA_MAESTRA ='"+(Math.round(prod2[2]))+"'");
                                                            if(resMat.next())
                                                            {
                                                                cant+=(resMat.getDouble("cantMat")*prod2[1]);
                                                            }
                                                        }
                                                        resMat.close();
                                                        stMat.close();
                                                        resultado2=formatoNumero.format(cant);
                                                    }
                                                 contSubproces++;
                                                 espEquipSubProces+=((espEquipSubProces.equals("")?"":",")+"'"+resdd.getString("NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE")+"','"+
                                                    resultado2+" "+resdd.getString("unidad")+(resdd.getDouble("tolerancia")>0?(" ±"+formatoNumero.format(resdd.getDouble("tolerancia"))+" "+resdd.getString("unidad") ):"")+"'");
                                             }
                                         }
                                         maquinariasSubProces+=cabeceraSubProces.equals("")?"":((maquinariasSubProces.equals("")?"":",")+"['"+cabeceraSubProces+"',["+espEquipSubProces+"]]");
                                         cabeceraSubProces=maqSubProcess;

                                /*consulta="SELECT m.NOMBRE_MATERIAL,sppem.CANTIDAD ,fmd.CANTIDAD as cantidadFm,um.ABREVIATURA" +
                                        ",ISNULL(fmdsub.CANTIDAD,0) as cantidadCompprod2"+
                                         " FROM SUB_PROCESOS_PRODUCTO_ESP_MAT sppem inner join MATERIALES m"+
                                         " on m.COD_MATERIAL=sppem.COD_MATERIAL inner join FORMULA_MAESTRA_DETALLE_MP"+
                                         " fmd on fmd.COD_FORMULA_MAESTRA=sppem.COD_FORMULA_MAESTRA and"+
                                         " fmd.COD_MATERIAL=sppem.COD_MATERIAL"+
                                         " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=fmd.COD_UNIDAD_MEDIDA" +
                                         " left outer join FORMULA_MAESTRA_DETALLE_MP fmdsub on fmdsub.COD_MATERIAL=sppem.COD_MATERIAL and fmdsub.COD_FORMULA_MAESTRA='"+(loteMix?Math.round(prod2[2]):0)+"'"+
                                         " where  sppem.COD_SUB_PROCESO_PRODUCTO='"+codSubProcesoProd+"'"+
                                         " and sppem.COD_PROCESO_PRODUCTO='"+codProcesoProd+"' and sppem.COD_FORMULA_MAESTRA='"+(Math.round(prod1[2]))+"'";//loteMix?Math.round(prod2[2]):
                                              */
                                consulta="SELECT m.NOMBRE_MATERIAL,fmd.CANTIDAD AS cantidadFm, um.ABREVIATURA, sum(fmdf.CANTIDAD) as cantidadFracciones,"+
                                         " ISNULL(fmdsub.CANTIDAD, 0) AS cantidadCompprod2 " +
                                         " FROM SUB_PROCESOS_PRODUCTO_ESP_MAT sppem INNER JOIN MATERIALES m ON m.COD_MATERIAL = sppem.COD_MATERIAL"+
                                         " INNER JOIN FORMULA_MAESTRA_DETALLE_MP fmd ON fmd.COD_FORMULA_MAESTRA = sppem.COD_FORMULA_MAESTRA"+
                                         " AND fmd.COD_MATERIAL = sppem.COD_MATERIAL"+
                                         " inner join FORMULA_MAESTRA_DETALLE_MP_FRACCIONES fmdf on fmdf.COD_FORMULA_MAESTRA=fmd.COD_FORMULA_MAESTRA"+
                                         " and m.COD_MATERIAL=fmdf.COD_MATERIAL and fmdf.COD_FORMULA_MAESTRA_FRACCIONES=sppem.COD_FORMULA_MAESTRA_FRACCIONES"+
                                         " INNER JOIN UNIDADES_MEDIDA um ON um.COD_UNIDAD_MEDIDA = fmd.COD_UNIDAD_MEDIDA"+
                                         " LEFT OUTER JOIN FORMULA_MAESTRA_DETALLE_MP fmdsub ON fmdsub.COD_MATERIAL = sppem.COD_MATERIAL"+
                                         " AND fmdsub.COD_FORMULA_MAESTRA = '"+(loteMix?Math.round(prod2[2]):0)+"'"+
                                         " WHERE sppem.COD_SUB_PROCESO_PRODUCTO = '"+codSubProcesoProd+"' AND sppem.COD_PROCESO_PRODUCTO = '"+codProcesoProd+"'"+
                                         " AND sppem.COD_FORMULA_MAESTRA = '"+(Math.round(prod1[2]))+"' group by m.NOMBRE_MATERIAL,fmd.CANTIDAD ,um.ABREVIATURA,fmdsub.CANTIDAD";
                                System.out.println("consulta materiales sub"+consulta);
                                 resdd=stdd.executeQuery(consulta);
                                materialesSubProceso="";
                                 while(resdd.next())
                                 {
                                     contSubproces++;
                                     porciento=(loteMix?(resdd.getDouble("cantidadFracciones")/resdd.getDouble("cantidadFm")):0);
                                     materialesSubProceso+=((materialesSubProceso.equals("")?"":",")+"'"+resdd.getString("NOMBRE_MATERIAL")+"','"+
                                             nf.format(loteMix?((resdd.getDouble("cantidadFracciones")*prod1[1])+(resdd.getDouble("cantidadCompprod2")*prod2[1]*porciento)):(resdd.getDouble("cantidadFracciones")*prod1[1]))+
                                        //nf.format((resdd.getDouble("CANTIDAD")*resdd.getDouble("PORCIENTO_MATERIAL")*prod1[1])+(prod2[2]==null?0:((resdd.getDouble("cantidadCompprod2")*resdd.getDouble("PORCIENTO_MATERIAL")*prod2[1]))))+
                                        " ("+resdd.getString("ABREVIATURA")+")'");
                                 }

                                script+="var p"+codProcesoProd+"s"+codSubProceso+"= uml.State.create({rect: {x:250, y: "+(subprocesoDer?posYder:posYizq)+", width: 400, height:"+(contSubproces+(descripcionSubProces.equals("")?0:6))*18+"},"+
                                        "label: '"+nroPasoProceso+"."+nroPasoSubProceso+" -Actividad:"+resd.getString("NOMBRE_ACTIVIDAD_PREPARADO")+(tiempoSubProces>0?" -Tiempo :"+tiempoSubProces+" " +
                                        "min-Tolerancia:"+nf.format((resd.getDouble("PORCIENTO_TOLERANCIA_TIEMPO_SUB_PROCESO")/100)*tiempoSubProces)+" min ":"")+"-Operario Tiempo Completo:"+(operarioTiempoCompletoSubProceso>0?"SI":"NO")+
                                        "',attrs: {fill:'90-#000-"+(operarioTiempoCompletoSubProceso>0?"#90EE90":"#FFC0CB")+":1-#fff'}," +
                                        (materialesSubProceso.equals("")?"":"materiales:["+materialesSubProceso+"],")+
                                        (maquinariasSubProces.equals("")?"":("datosMaq:["+maquinariasSubProces+"],"))+
                                        "personal1:'"+personalSubProceso1+"',"+
                                        "personal2:'"+personalSubProceso2+"',"+
                                        "conforme:"+conformeSubProceso+","+
                                        "observacion:'"+observacionSubProceso+"',"+

                                        //(descripcionSubProces.equals("")?"":"descripcion:'"+descripcionSubProces.replace(b, '&').replace(c,' ')+"',")+
                                        "actions:{actividad:null," +
                                        "Maquinaria:'ninguno'"+
                                        (espEquipSubProces.equals("")?"":",inner: ["+espEquipSubProces+"]") +
                                        "},descripcion:'"+descripcionSubProces.replace(b, '-').replace(c,' ')+"'" +
                                        ",detailsOffsetY:"+(tiempoSubProces>0?"5":"3")+",codProcesos:'"+codProceso+"',codSubProceso:'"+codSubProceso+"'});";

                                variables+=(variables.equals("")?"":",")+"p"+codProcesoProd+"s"+codSubProceso;
                                posYizq+=(subprocesoDer?0:((contSubproces+(descripcionSubProces.equals("")?0:6))*18)+21);
                                posYder+=(subprocesoDer?((contSubproces+(descripcionSubProces.equals("")?0:6))*18)+21:0);
                                primerRegistro=false;

                           }
                    }
                    String areglo="";
                    String arrow="";
                    int cont=0;
                    for(String[] var:listaPuntos)
                    {
                        areglo+=(areglo.equals("")?"":",")+var[0]+","+var[1];
                        arrow+=" var m"+cont+"="+var[0]+".joint("+var[1]+", uml.arrow).register(all);";
                        if(var[2].equals("1"))
                        {
                        arrow+="asignarPuntos(m"+cont+");";
                        }
                        if(var[2].equals("2"))
                        {
                        arrow+="crunch(m"+cont+");";
                        }
                        if(var[2].equals("5"))
                        {
                        arrow+="crunch2(m"+cont+");";
                        }
                        arrow+="verificarInterupcion(m"+cont+");";
                        cont++;
                    }
                    //System.out.println(arrow);
                    scriptUnion+="var all = ["+areglo+"];";

                   out.println("var nccc");
                   
                    scriptUnion+=arrow;
                  //  System.out.println(scriptUnion);
                   // System.out.println(script);
                    int height=posYcen;
                    height=height>posYder?height:posYder;
                    height=height>posYizq?height:posYizq;
                    System.out.println("h" +height);
                    out.println(" var paper = Joint.paper('diagrama', 1000, "+ height+");"+script+scriptUnion);
                    std.close();
               %>

       </script>


                        <%
                        res.close();
                        con.close();
                    
                    }catch(SQLException ex)
                    {
                        ex.printStackTrace();
                    }
                if(Integer.valueOf(request.getParameter("imp"))>0)
                {
                    out.println("<script>window.print();</script>");
                }
                %>
                
    </body>
</html>
