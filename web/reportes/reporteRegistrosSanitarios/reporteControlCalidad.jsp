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
<%@page import="java.text.DecimalFormatSymbols" %>
<%@ page import = "java.text.NumberFormat"%>
<%@ page language="java" import="java.util.*,com.cofar.util.CofarConnection" %>
<%@ page errorPage="ExceptionHandler.jsp" %>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<%!
private boolean verificarResultadoAprobar(String codTipoResultadoAnalisis,String codTipoResultadoDescriptivo,double resultadoNumerico,double limiteSuperior,double limiteInferior,double valorExacto)
    {
        boolean resultado=true;
        if(codTipoResultadoAnalisis.equals("1"))
        {
            if(codTipoResultadoDescriptivo.equals("2"))
            {   
                return false;
            }
        }
        if(codTipoResultadoAnalisis.equals("2"))
        {
            if((resultadoNumerico>limiteSuperior)||(resultadoNumerico<limiteInferior))
            {
                return false;
            }
        }
        if(codTipoResultadoAnalisis.equals("3"))
        {
            if(resultadoNumerico!=valorExacto)
            {
                return false;
            }
        }
        if(codTipoResultadoAnalisis.equals("4"))
        {
            if(resultadoNumerico<=valorExacto)
            {
                return false;
            }
        }
        if(codTipoResultadoAnalisis.equals("5"))
        {
            if(resultadoNumerico>=valorExacto)
            {
                return false;
            }
        }
        if(codTipoResultadoAnalisis.equals("6"))
        {
            if(resultadoNumerico<valorExacto)
            {
                return false;
            }
        }
        if(codTipoResultadoAnalisis.equals("7"))
        {
            if(resultadoNumerico>valorExacto)
            {
               return false;
            }
        }
        if(codTipoResultadoAnalisis.equals("8"))
        {
            if((resultadoNumerico<(-valorExacto))||(resultadoNumerico>valorExacto))
            {
                return false;
            }
        }
        return resultado;
    }

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
    </head>
    <body>
        <form>
             <%
                    String codLote=request.getParameter("codLote");
                    String codProd=request.getParameter("codProd");
                    String codFormaRequest=request.getParameter("codForma");
                    String codComprod="";
                    Date fechaEmision=new Date();
                    String nombreProducto="";
                    String nombreForma="";
                    String nombreAnalisis="";
                    String tipoEspecificacionFisica="";
                    String nombreEspecificacion="";
                    String nombreReferencia="";
                    String resultado="";
                    String codEspecificacion="";
                    String nombreMaterial="";
                    String nombreAnalista="";
                    String nombrePresentacion="";
                    String nroAnalisis="";
                    String nombreJefeControldeCalidad="";
                    String urlFirmaJefeControlDeCalidad="";
                    String fechaElaboracion="";
                    String fechaVencimiento="";
                    SimpleDateFormat sdt= new SimpleDateFormat("MM/yyyy");
                    String tamLote="";
                    String nombreAreaEmpresa="";
                    String dictamen="";
                    String tomo="";
                    String pagina="";
                    String urlFirma="";
                    boolean aprobado=true;
                   DecimalFormatSymbols simbolo1=new DecimalFormatSymbols();
                        simbolo1.setDecimalSeparator(',');
                        simbolo1.setGroupingSeparator('.');
                    DecimalFormat formatoMil = new DecimalFormat("###,###.##",simbolo1);
                    formatoMil.setMaximumFractionDigits(2);
                    NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        DecimalFormat formato = (DecimalFormat) numeroformato;
                        formato.applyPattern("#,##0.00");
                        
                    int codDescriptivo=0;
                    Connection con=null;
                    try{
                        con=Util.openConnection(con);
                        String consulta="select pp.COD_TIPO_PROGRAMA_PROD from PROGRAMA_PRODUCCION pp where pp.COD_ESTADO_PROGRAMA not in(3,8,9) and pp.COD_LOTE_PRODUCCION='"+codLote+"' and pp.COD_PROGRAMA_PROD in ("+
                                         " select p.COD_PROGRAMA_PROD from PROGRAMA_PRODUCCION_PERIODO p where p.COD_TIPO_PRODUCCION=1 and p.COD_ESTADO_PROGRAMA<>4)";
                        System.out.println("consulta buscar lote "+consulta);
                        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet res=st.executeQuery(consulta);
                        String codTipoProgramaProd="";
                        while(res.next())
                        {
                            codTipoProgramaProd+=(codTipoProgramaProd.equals("")?"":",")+res.getString("COD_TIPO_PROGRAMA_PROD");
                        }
                        String codProgramaprod="";
                        consulta=" select max(pp.COD_PROGRAMA_PROD) as codProg from PROGRAMA_PRODUCCION pp where pp.cod_estado_programa<>3 and pp.COD_LOTE_PRODUCCION='"+codLote+"' and pp.COD_PROGRAMA_PROD in ("+
                                         " select p.COD_PROGRAMA_PROD from PROGRAMA_PRODUCCION_PERIODO p where p.COD_TIPO_PRODUCCION=1 and p.COD_ESTADO_PROGRAMA<>4)";
                        System.out.println("concc "+consulta);
                        res=st.executeQuery(consulta);
                        if(res.next())
                            {
                            codProgramaprod=res.getString("codProg");
                        }
                        consulta="select  pr.nombre_prod,ra.FECHA_EMISION,ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA,"+
                                     " isnull(ra.NRO_ANALISIS_MICROBIOLOGICO, '') as NRO_ANALISIS_MICROBIOLOGICO,"+
                                     " ra.NRO_ANALISIS,cp.VIDA_UTIL,cp.nombre_prod_semiterminado,cp.COD_COMPPROD,"+
                                     " ff.nombre_forma,(p.NOMBRE_PILA + ' ' + p.AP_PATERNO_PERSONAL + ' ' +p.AP_MATERNO_PERSONAL) as nombreAnalista,"+
                                     " ISNULL((select top 1 spp.FECHA_INICIO from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp"+
                                     " inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA = spp.COD_ACTIVIDAD_PROGRAMA and"+
                                     " spp.COD_FORMULA_MAESTRA = afm.COD_FORMULA_MAESTRA where spp.COD_LOTE_PRODUCCION = ra.COD_LOTE and afm.COD_ACTIVIDAD = 186"+
                                     " order by spp.FECHA_FINAL DESC ), (select top 1 spp1.FECHA_INICIO from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp1"+
                                     " inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA = spp1.COD_ACTIVIDAD_PROGRAMA and"+
                                     " spp1.COD_FORMULA_MAESTRA = afm.COD_FORMULA_MAESTRA where spp1.COD_LOTE_PRODUCCION = ra.COD_LOTE and afm.COD_ACTIVIDAD =76"+
                                     " order by spp1.FECHA_FINAL DESC )) as fecha,pp1.CANT_LOTE_PRODUCCION,tpp.ABREVIATURA,fccc.URL_FIRMA,era.COD_ESTADO_RESULTADO_ANALISIS,"+
                                     " era.NOMBRE_ESTADO_RESULTADO_ANALISIS,ra.TOMO,ra.PAGINA,ff.cod_forma,(cast (cp.CANTIDAD_VOLUMEN as varchar) + ' ' + um.ABREVIATURA) as VOLUMEN_ENVASE_PRIMARIO,cp.CONCENTRACION_ENVASE_PRIMARIO,"+
                                     " cp.PESO_ENVASE_PRIMARIO,ff.nombre_forma,cp.nombre_prod_semiterminado,cpprim.NOMBRE_COLORPRESPRIMARIA,isnull(("+
                                     " select top 1 cast (ep.nombre_envaseprim as varchar) + '%' + cast(ppcp.CANTIDAD as varchar) from PRESENTACIONES_PRIMARIAS_VERSION ppcp"+
                                     " inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim =ppcp.COD_ENVASEPRIM where ppcp.COD_COMPPROD = cp.COD_COMPPROD and ppcp.COD_VERSION=cp.COD_VERSION and "+
                                     " ppcp.COD_TIPO_PROGRAMA_PROD = pp1.COD_TIPO_PROGRAMA_PROD), '') as presentacionPrimaria" +
                                     " ,ra.COD_VERSION_CONCENTRACION,ra.COD_VERSION_ESPECIFICACION_FISICA,ra.COD_VERSION_ESPECIFICACION_MICRO,ra.COD_VERSION_ESPECIFICACION_QUIMICA" +
                                     " ,pp1.COD_COMPPROD_VERSION"+
                                     ",fcj.URL_FIRMA as urlFirmeJEfeCC"+
                                     ",('Dra. '+p1.NOMBRE_PILA+' '+p1.AP_PATERNO_PERSONAL+' '+p1.AP_MATERNO_PERSONAL) as jefeControlCCC"+
                                 " from PROGRAMA_PRODUCCION pp1 inner join COMPONENTES_PROD_VERSION cp on cp.COD_COMPPROD = pp1.COD_COMPPROD"+
                                 " and cp.COD_VERSION=pp1.COD_COMPPROD_VERSION inner join FORMAS_FARMACEUTICAS ff on "+
                                 " cp.COD_FORMA=ff.cod_forma  inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=cp.COD_AREA_EMPRESA"+
                                 " left outer join COLORES_PRESPRIMARIA cpprim on cpprim.COD_COLORPRESPRIMARIA= cp.COD_COLORPRESPRIMARIA inner join productos pr on pr.cod_prod=cp.COD_PROD"+
                                 " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp1.COD_TIPO_PROGRAMA_PROD"+
                                 " left outer join RESULTADO_ANALISIS ra on ra.cod_lote=pp1.COD_LOTE_PRODUCCION"+
                                 " and ra.COD_COMPROD=pp1.COD_COMPPROD and ra.COD_ESTADO_RESULTADO_ANALISIS <> 3"+
                                 " left outer join PERSONAL p on p.COD_PERSONAL = ra.COD_PERSONAL_ANALISTA"+
                                 " left outer join FIRMAS_CERTIFICADO_CC fccc on fccc.COD_PERSONAL =ra.COD_PERSONAL_ANALISTA"+
                                 " left outer join FIRMAS_CERTIFICADO_CC fcj on fcj.COD_PERSONAL=ra.COD_PERSONAL_APRUEBA_CCC"+
                                 " left outer join personal p1 on p1.COD_PERSONAL=ra.COD_PERSONAL_APRUEBA_CCC"+
                                 " left outer join ESTADOS_RESULTADO_ANALISIS era on era.COD_ESTADO_RESULTADO_ANALISIS = ra.COD_ESTADO_RESULTADO_ANALISIS" +
                                 " left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA = cp.COD_UNIDAD_MEDIDA_VOLUMEN"+
                                 " where pp1.COD_LOTE_PRODUCCION = '"+codLote+"' and pp1.COD_PROGRAMA_PROD = '"+codProgramaprod+"'" +
                                 " and pr.COD_PROD='"+codProd+"'"+
                                 " and cp.cod_forma='"+codFormaRequest+"'"+
                                 " ORDER BY ra.COD_COMPROD desc";
                        System.out.println("consulta cabecera "+consulta);
                        res=st.executeQuery(consulta);
                        Statement stdetalle=null;
                        ResultSet resdetalle=null;

                        int codForma=0;
                        String presentacion="";
                        String codEstado="";
                        String nroAnalisisMicrobiologico="";
                        String codAreaEmpresa="";
                        String nombreTipo="";
                        int codVersionFisica=0;
                        int codVersionMicro=0;
                        int codVersionQuimica=0;
                        int codVersionConcentracion=0;
                        int codVersion=0;
                        if(res.next())
                        {
                            urlFirmaJefeControlDeCalidad=res.getString("urlFirmeJEfeCC");
                            nombreJefeControldeCalidad=res.getString("jefeControlCCC");
                            codVersion=res.getInt("COD_COMPPROD_VERSION");
                            codVersionFisica=res.getInt("COD_VERSION_ESPECIFICACION_FISICA");
                            codVersionQuimica=res.getInt("COD_VERSION_ESPECIFICACION_QUIMICA");
                            codVersionMicro=res.getInt("COD_VERSION_ESPECIFICACION_MICRO");
                            codVersionConcentracion=res.getInt("COD_VERSION_CONCENTRACION");
                            codAreaEmpresa=res.getString("COD_AREA_EMPRESA");
                            fechaEmision=(res.getTimestamp("FECHA_EMISION")==null?(new Date()):res.getTimestamp("FECHA_EMISION"));
                            nroAnalisisMicrobiologico=res.getString("NRO_ANALISIS_MICROBIOLOGICO");
                            codEstado=res.getString("COD_ESTADO_RESULTADO_ANALISIS");
                            codForma=res.getInt("cod_forma");
                            String presenPrimaria=(res.getString("presentacionPrimaria").split("%").length>0?res.getString("presentacionPrimaria").split("%")[0]:"");
                            String cantidadPresenPrimaria=(res.getString("presentacionPrimaria").split("%").length>1?res.getString("presentacionPrimaria").split("%")[1]:"");
                            String volumenPresenPrimaria=res.getString("VOLUMEN_ENVASE_PRIMARIO");
                            String conPresenPrimaria=res.getString("CONCENTRACION_ENVASE_PRIMARIO");
                            String pesoPresenPrimaria=res.getString("PESO_ENVASE_PRIMARIO");
                            String colorPresenPrimaria=res.getString("NOMBRE_COLORPRESPRIMARIA");
                            String nombreFormaFar=res.getString("nombre_forma");
                            String nombreFormaPresentacion="";
                                if((codForma==6||codForma==1||codForma==32||codForma==37||codForma==38||codForma==39||codForma==40||codForma==41||codForma==42))
                                {
                                    String[] array=nombreFormaFar.split(" ");
                                    for(String a:array)
                                    {
                                        nombreFormaPresentacion+=a+"s ";
                                    }

                                }
                            presentacion=presenPrimaria+" "+((codForma==2||codForma==14||codForma==33||codForma==16|| codForma==10||codForma==26||codForma==27||codForma==29)?colorPresenPrimaria+" por "+volumenPresenPrimaria:
                                         ((codForma==6||codForma==1||codForma==32||codForma==37||codForma==38||codForma==39||codForma==40||codForma==41||codForma==42)?"por "+cantidadPresenPrimaria+" "+nombreFormaPresentacion:
                                         ((codForma==7||codForma==25)?"por "+volumenPresenPrimaria:
                                         ((codForma==12||codForma==20||codForma==31||codForma==11||codForma==34||codForma==30||codForma==13)?"por "+pesoPresenPrimaria:
                                          ((codForma==36)?"por "+cantidadPresenPrimaria+"comprimidos":"") ))));
                            presentacion=presentacion.toLowerCase();
                            String a=String.valueOf(presentacion.charAt(0));
                            presentacion=presentacion.replaceFirst(a,a.toUpperCase());
                            tomo=res.getString("TOMO");
                            pagina=res.getString("PAGINA");
                            urlFirma=res.getString("URL_FIRMA");
                            dictamen=res.getString("NOMBRE_ESTADO_RESULTADO_ANALISIS");
                            nombreProducto=res.getString("nombre_prod").trim();
                            /*if(nombreProducto.length()>5)
                                {
                                    String nombreref=nombreProducto.substring(nombreProducto.length()-4, nombreProducto.length()).toLowerCase();
                                    if(nombreref.equals(" ref"))
                                    {
                                        nombreProducto=nombreProducto.substring(0,nombreProducto.length()-4);
                                    }
                                }*/
                            codComprod=res.getString("COD_COMPPROD");
                            nombreForma=res.getString("nombre_forma");
                            nroAnalisis=res.getString("NRO_ANALISIS");
                            nombreAnalista=res.getString("nombreAnalista");
                            //nombrePresentacion=res.getString("NOMBRE_PRODUCTO_PRESENTACION");
                            tamLote=res.getInt("CANT_LOTE_PRODUCCION")+" "+((codForma==1||codForma==6||codForma==32||codForma==37||codForma==38||codForma==39||codForma==40||codForma==41||codForma==42)?nombreFormaPresentacion:res.getString("presentacionPrimaria").split("%")[0]+"s");
                            tamLote=tamLote.toLowerCase();
                            nombreAreaEmpresa=res.getString("NOMBRE_AREA_EMPRESA");
                            if(res.getDate("fecha")!=null)
                            {

                                    fechaElaboracion=sdt.format(res.getDate("fecha"));
                                    int vidaUtil=res.getInt("VIDA_UTIL");
                                    if(res.getDate("fecha").getDate()>=27)
                                    {
                                        vidaUtil+=1;
                                    }
                                    
                                    System.out.println("vida "+vidaUtil);
                                    int years=Integer.valueOf(vidaUtil/12);
                                    vidaUtil-=(years*12);
                                    String[] fecha=fechaElaboracion.split("/");
                                    fechaVencimiento=String.valueOf(Integer.valueOf(fecha[0])+vidaUtil)+"/"+String.valueOf(Integer.valueOf(fecha[1])+years);
                            }
                            if(codAreaEmpresa.equals("81"))
                            {
                                consulta="select FECHA_VENCIMIENTO from INGRESOS_ALMACEN_DETALLE_ESTADO i inner join FORMULA_MAESTRA_DETALLE_EP_VERSION fmdep on fmdep.COD_MATERIAL = i.COD_MATERIAL" +
                                " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA = fmdep.COD_FORMULA_MAESTRA inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = fm.COD_COMPPROD " +
                                " where i.LOTE_MATERIAL_PROVEEDOR = '"+codLote.split("-")[0]+"' ";
                                System.out.println("consulta proovedor "+consulta);
                                Statement stdet=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                ResultSet resDet=stdet.executeQuery(consulta);
                                SimpleDateFormat sdf2=new SimpleDateFormat("MM/yyyy");
                                if(resDet.next())
                                {
                                    fechaVencimiento=sdf2.format(resDet.getDate("FECHA_VENCIMIENTO"));
                                }
                                if((codComprod.equals("7")||codComprod.equals("8"))&&res.getDate("fecha")==null)
                                    {
                                        consulta="select MIN(spp.FECHA_INICIO) as fechaInicio"+
                                                 " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp inner join ACTIVIDADES_FORMULA_MAESTRA afm"+
                                                 " on spp.COD_ACTIVIDAD_PROGRAMA=afm.COD_ACTIVIDAD_FORMULA and spp.COD_FORMULA_MAESTRA=afm.COD_FORMULA_MAESTRA"+
                                                 " and afm.COD_AREA_EMPRESA=96"+
                                                 " where afm.COD_ACTIVIDAD in (71,48) and spp.COD_LOTE_PRODUCCION='"+codLote+"'";
                                        System.out.println("consulta buscar fecha elaboracion "+consulta);
                                        resDet=stdet.executeQuery(consulta);
                                        if(resDet.next())
                                        {
                                           if(resDet.getDate("fechaInicio")!=null)
                                           {
                                               fechaElaboracion=sdt.format(resDet.getDate("fechaInicio"));
                                           }
                                           else
                                           {
                                               consulta="select MIN(spp.FECHA_INICIO) as fechaInicio"+
                                                        " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp inner join ACTIVIDADES_FORMULA_MAESTRA afm"+
                                                        " on spp.COD_ACTIVIDAD_PROGRAMA=afm.COD_ACTIVIDAD_FORMULA and spp.COD_FORMULA_MAESTRA=afm.COD_FORMULA_MAESTRA"+
                                                        " and afm.COD_AREA_EMPRESA=96"+
                                                        " where afm.COD_ACTIVIDAD in (29,40,88) and spp.COD_LOTE_PRODUCCION='"+codLote+"'";
                                               System.out.println("consulta buscar fecha envasado "+consulta);
                                               resDet=stdet.executeQuery(consulta);
                                               if(resDet.next())
                                               {
                                                   fechaElaboracion=sdt.format(resDet.getDate("fechaInicio"));
                                               }
                                           }
                                        }
                                    }
                                resDet.close();
                                stdet.close();
                            }
                            nombreTipo=res.getString("ABREVIATURA");
                        }
                        if(res.next())
                        {
                             String presenPrimaria=(res.getString("presentacionPrimaria").split("%").length>0?res.getString("presentacionPrimaria").split("%")[0]:"");
                            String cantidadPresenPrimaria=(res.getString("presentacionPrimaria").split("%").length>1?res.getString("presentacionPrimaria").split("%")[1]:"");
                            String volumenPresenPrimaria=res.getString("VOLUMEN_ENVASE_PRIMARIO");
                            String conPresenPrimaria=res.getString("CONCENTRACION_ENVASE_PRIMARIO");
                            String pesoPresenPrimaria=res.getString("PESO_ENVASE_PRIMARIO");
                            String colorPresenPrimaria=res.getString("NOMBRE_COLORPRESPRIMARIA");
                            String nombreFormaFar=res.getString("nombre_forma");
                            codForma=res.getInt("cod_forma");
                            String nombreFormaPresentacion="";
                                if((codForma==6||codForma==1||codForma==32||codForma==37||codForma==38||codForma==39||codForma==40||codForma==41||codForma==42))
                                {
                                    String[] array=nombreFormaFar.split(" ");
                                    for(String a:array)
                                    {
                                        nombreFormaPresentacion+=a+"s ";
                                    }

                                }
                            String pres2=presenPrimaria+" "+((codForma==2||codForma==14||codForma==33||codForma==16|| codForma==10||codForma==26||codForma==27||codForma==29)?colorPresenPrimaria+" por "+volumenPresenPrimaria:
                                         ((codForma==6||codForma==1||codForma==32||codForma==37||codForma==38||codForma==39||codForma==40||codForma==41||codForma==42)?"por "+cantidadPresenPrimaria+" "+nombreFormaPresentacion:
                                         ((codForma==7||codForma==25)?"por "+volumenPresenPrimaria:
                                         ((codForma==12||codForma==20||codForma==31||codForma==11||codForma==34||codForma==30||codForma==13)?"por "+pesoPresenPrimaria:
                                          ((codForma==36)?"por "+cantidadPresenPrimaria+"comprimidos":"") ))));
                            presentacion+="("+nombreTipo+") <br/> "+pres2.toLowerCase()+" ("+res.getString("ABREVIATURA")+")";
                            String ta=res.getInt("CANT_LOTE_PRODUCCION")+" "+((codForma==1||codForma==6||codForma==32||codForma==37||codForma==38||codForma==39||codForma==40||codForma==41||codForma==42)?nombreFormaPresentacion:res.getString("presentacionPrimaria").split("%")[0]+"s");
                            ta=ta.toLowerCase();
                            /*char[] ad=ta.toCharArray();
                            if(ad[ad.length-1]!='s')
                              ta+="s";*/
                            tamLote+=" ("+nombreTipo+") <br/> "+ta+" ("+res.getString("ABREVIATURA")+")";
                        }
                        consulta="select m.NOMBRE_CCC,cpc.CANTIDAD,um.ABREVIATURA,cpc.UNIDAD_PRODUCTO"+
                                ",cpc.NOMBRE_MATERIAL_EQUIVALENCIA,cpc.CANTIDAD_EQUIVALENCIA,isnull(ume.ABREVIATURA,'') as abreEquivalencia"+
                                 " from COMPONENTES_PROD_CONCENTRACION cpc inner join materiales m"+
                                 " on cpc.COD_MATERIAL=m.COD_MATERIAL inner join UNIDADES_MEDIDA um on "+
                                 " um.COD_UNIDAD_MEDIDA=cpc.COD_UNIDAD_MEDIDA"+
                                 " left outer join UNIDADES_MEDIDA ume on ume.COD_UNIDAD_MEDIDA=cpc.COD_UNIDAD_MEDIDA_EQUIVALENCIA"+
                                 " where cpc.COD_ESTADO_REGISTRO=1 and cpc.COD_COMPPROD='"+codComprod+"' and cpc.EXCIPIENTE<>1" +
                                 (codVersionConcentracion>0?" and cpc.COD_VERSION_ESPECIFICACION_PRODUCTO='"+codVersionConcentracion+"'":" and cpc.COD_VERSION='"+codVersion+"'")+
                                 " order by m.NOMBRE_CCC";
                        System.out.println("consulta concentracion "+consulta);
                        res=st.executeQuery(consulta);
                        String concentracion="";
                        String porUnidadProd="";
                        if(res.next())
                        {
                            concentracion=res.getString("NOMBRE_CCC")+" "+formatoMil.format(res.getDouble("CANTIDAD"))+" "+res.getString("ABREVIATURA");
                            concentracion+=(res.getInt("CANTIDAD_EQUIVALENCIA")>0?(" equivalente a "+res.getString("NOMBRE_MATERIAL_EQUIVALENCIA")+" "+formatoMil.format(res.getDouble("CANTIDAD_EQUIVALENCIA"))+" "+res.getString("abreEquivalencia")):"");
                            porUnidadProd=res.getString("UNIDAD_PRODUCTO");
                        }
                        while(res.next())
                        {
                            concentracion+=", "+res.getString("NOMBRE_CCC")+" "+formatoMil.format(res.getDouble("CANTIDAD"))+" "+res.getString("ABREVIATURA");//res.getString("datoMaterial");
                            concentracion+=(res.getInt("CANTIDAD_EQUIVALENCIA")>0?(" equivalente a "+res.getString("NOMBRE_MATERIAL_EQUIVALENCIA")+" "+formatoMil.format(res.getDouble("CANTIDAD_EQUIVALENCIA"))+" "+res.getString("abreEquivalencia")):"");
                        }
                        concentracion+=(porUnidadProd.equals("")?"":" / ")+porUnidadProd;
             %>
            <center><img src="../../img/cofar.png"></center>
            <h4 align="center">CERTIFICADO DE ANÁLISIS <%=nombreAreaEmpresa%></h4>
            <h4 align="center">DEPARTAMENTO DE CONTROL DE CALIDAD</h4>
            <table width="100%" align="center"  style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >
                <tr >
                    <td class="outputText2" ><b>PRODUCTO:&nbsp;</b></td><td class="outputText2"><%=nombreProducto%></td>
                    <td class="outputText2"><b>LOTE:&nbsp;</b></td><td class="outputText2"><%=codLote%></td>
                </tr>
                <tr >
                    <td style="padding-top:4px" class="outputText2"><b>FORMA FARMACEUTICA:&nbsp;</b></td><td style="padding-top:4px" class="outputText2"><%=nombreForma%></td>
                    <td style="padding-top:4px" class="outputText2"><b>PRESENTACION:&nbsp;</b></td><td style="padding-top:4px" class="outputText2"><%=presentacion%></td>
                </tr>
                <tr >
                    <td style="padding-top:4px"class="outputText2"><b>FECHA DE ELABORACIÓN:&nbsp;</b></td><td style="padding-top:4px" class="outputText2"><%=fechaElaboracion%></td>
                    <td style="padding-top:4px" class="outputText2"><b>FECHA DE VENCIMIENTO:&nbsp;</b></td><td style="padding-top:4px" class="outputText2"><%=fechaVencimiento%></td>
                </tr>
                <tr >
                    <td style="padding-top:4px"  rowspan="2" class="outputText2"><b>TAMAÑO DEL LOTE:&nbsp;</b></td><td style="padding-top:4px" rowspan="2" class="outputText2"><%=tamLote%></td>
                    <td style="padding-top:4px" class="outputText2"><b>N° ANÁLISIS FÍSICO QUÍMICO:&nbsp;</b></td><td style="padding-top:4px" class="outputText2"><%=nroAnalisis%></td>
                </tr>
                <tr >
                    
                 <td style="padding-top:4px" class="outputText2"><b>N° ANÁLISIS MICROBIOLÓGICO:&nbsp;</b></td><td style="padding-top:4px" class="outputText2"><%=nroAnalisisMicrobiologico%></td>
                </tr>
                <%
                    out.println(concentracion.equals("")?"":
                           ("<tr ><td style='padding-top:4px' colspan='' class='outputText2'><b>CONCENTRACIÓN:&nbsp;</b></td><td style='padding-top:4px' align='left' colspan='3' class='outputText2'>"+concentracion+"</td></tr>"));
                %>

                 
                
            </table>
          
           
             <table width="100%" align="center" class="outputText0" style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >

                <%
                consulta="select rae.COD_TIPO_RESULTADO_DESCRIPTIVO,efcc.NOMBRE_ESPECIFICACION,efp.LIMITE_INFERIOR,efp.LIMITE_SUPERIOR,efp.VALOR_EXACTO," +
                         " efp.DESCRIPCION,tr.NOMBRE_REFERENCIACC,isnull(trd.NOMBRE_TIPO_RESULTADO_DESCRIPTIVO,'') as NOMBRE_TIPO_RESULTADO_DESCRIPTIVO,"+
                         " rae.RESULTADO_NUMERICO,efcc.COD_TIPO_RESULTADO_ANALISIS," +
                         "ISNULL(tra.SIMBOLO,'')as SIMBOLO,ISNULL(efcc.COEFICIENTE,'') as COEFICIENTE,ISNULL(efcc.unidad,'') as unidad" +
                         " ,isnull(tef.NOMBRE_TIPO_ESPECIFICACION_FISICA,'') as nombreTipoEspecificacion"+
                         " from ESPECIFICACIONES_FISICAS_PRODUCTO efp inner join ESPECIFICACIONES_FISICAS_CC efcc"+
                         " on efp.COD_ESPECIFICACION=efcc.COD_ESPECIFICACION inner join TIPOS_REFERENCIACC tr on"+
                         " tr.COD_REFERENCIACC=efp.COD_REFERENCIA_CC "+
                         " inner join RESULTADO_ANALISIS_ESPECIFICACIONES rae on rae.COD_TIPO_ANALISIS=1" +
                         " and rae.COD_COMPPROD=efp.COD_PRODUCTO"+
                         " and  rae.COD_ESPECIFICACION=efcc.COD_ESPECIFICACION left outer join TIPO_RESULTADO_DESCRIPTIVO trd"+
                         " on trd.COD_TIPO_RESULTADO_DESCRIPTIVO=rae.COD_TIPO_RESULTADO_DESCRIPTIVO" +
                         " left outer join TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS=efcc.COD_TIPO_RESULTADO_ANALISIS" +
                         " left outer join TIPOS_ESPECIFICACIONES_FISICAS tef on"+
                         " tef.COD_TIPO_ESPECIFICACION_FISICA=efp.COD_TIPO_ESPECIFICACION_FISICA"+
                         " where efp.COD_PRODUCTO='"+codComprod+"'"+
                        (codVersionQuimica>0?" and efp.COD_VERSION_ESPECIFICACION_PRODUCTO='"+codVersionFisica+"'":" and efp.COD_VERSION='"+codVersion+"'")+
                         " and rae.COD_LOTE='"+codLote+"' order by isnull(tef.NOMBRE_TIPO_ESPECIFICACION_FISICA,''),efcc.NOMBRE_ESPECIFICACION";
                System.out.println("consulta analisis fisico "+consulta);
                res=st.executeQuery(consulta);
                double limiteSuperior=0d;
                double limiteInferior=0d;
                double valorExacto=0d;
                double resultadoNumerico=0d;
                String codTipoResultadoAnalisis="";
                String simbolo="";
                String coeficiente="";
                String unidad="";
                String descripcion="";
                boolean conExponente=false;
                boolean primerRegistro=true;
                String cabeceraEspecificacion="";
                String nombreTipoResultado="";
                while(res.next())
                    {
                    tipoEspecificacionFisica=res.getString("nombreTipoEspecificacion");
                    nombreAnalisis=res.getString("NOMBRE_ESPECIFICACION");
                    codTipoResultadoAnalisis=res.getString("COD_TIPO_RESULTADO_ANALISIS");
                    nombreReferencia=res.getString("NOMBRE_REFERENCIACC");
                    limiteInferior=res.getDouble("LIMITE_INFERIOR");
                    limiteSuperior=res.getDouble("LIMITE_SUPERIOR");
                    valorExacto=res.getDouble("VALOR_EXACTO");
                    resultadoNumerico=res.getDouble("RESULTADO_NUMERICO");
                    simbolo=res.getString("SIMBOLO");
                    coeficiente=res.getString("COEFICIENTE");
                    unidad=res.getString("unidad");
                    nombreTipoResultado=res.getString("NOMBRE_TIPO_RESULTADO_DESCRIPTIVO");
                    if(primerRegistro)
                    {
                        cabeceraEspecificacion=tipoEspecificacionFisica;
                        if(!cabeceraEspecificacion.equals(""))
                        {
                            %>
                            <tr bgcolor="#eeeeee" >
                                <td class='border' align='center' colspan="4" ><b><%=cabeceraEspecificacion%></b></td>
                            </tr>
                            <%
                        }
                        %>
                         <tr bgcolor="#dddddd">
                                <td class='border' align='center' style='border:1px solid #cccccc;padding:8px'><b>ANALISIS FISICO</b></td>
                                <td class='border' align='center' style='border:1px solid #cccccc;padding:8px'><b>ESPECIFICACIONES</b></td>
                                <td class='border' align='center' style='border:1px solid #cccccc;padding:8px'><b>REFERENCIA</b></td>
                                <td class='border' align='center' style='border:1px solid #cccccc;padding:8px'><b>RESULTADOS</b></td>

                          </tr>
                        <%
                        primerRegistro=false;
                    }
                    else
                    {
                        if(!cabeceraEspecificacion.equals(tipoEspecificacionFisica))
                         {
                            cabeceraEspecificacion=tipoEspecificacionFisica;
                            %>
                            <tr bgcolor="#eeeeee" >
                                
                                <td class='border' align='center' colspan="4" ><b><%=cabeceraEspecificacion%></b></td>
                            </tr>
                            <%
                         }
                    }
                    nombreEspecificacion=((codTipoResultadoAnalisis.equals("1")?res.getString("DESCRIPCION"):
                        (codTipoResultadoAnalisis.equals("2")?(String.valueOf(limiteInferior)+" "+unidad+"-"+String.valueOf(limiteSuperior)+" "+unidad):
                        (coeficiente+" "+(simbolo.equals(">=")?"≥":(simbolo.equals("<=")?"≤":simbolo))+" "+String.valueOf(valorExacto)+" "+unidad))));
                    resultado=(codTipoResultadoAnalisis.equals("1")?nombreTipoResultado:(nombreTipoResultado.equals("")?(String.valueOf(resultadoNumerico)+" "+unidad):nombreTipoResultado));
                    if(!verificarResultadoAprobar(codTipoResultadoAnalisis,res.getString("COD_TIPO_RESULTADO_DESCRIPTIVO"), resultadoNumerico, limiteSuperior, limiteInferior, valorExacto))
                    {
                        aprobado=false;
                    }
                    

                %>
                 <tr >
                    <td class='border' align='left'  ><%=nombreAnalisis%></td>
                    <td class='border' align='left' ><%=nombreEspecificacion%></td>
                    <td class='border' align='left' ><%=nombreReferencia%></td>
                    <td class='border' align='left' ><%=resultado%></td>
                   </tr>
                <%
                }
                
                %>
              <tr bgcolor="#dddddd">
                    <td class='border' align='center' style='border:1px solid #cccccc;padding:8px' colspan="4"><b>ANALISIS QUIMICO</b></td>
              </tr>
              <%
              consulta="select eqcc.COD_ESPECIFICACION,eqcc.NOMBRE_ESPECIFICACION,eqcc.COD_TIPO_RESULTADO_ANALISIS," +
                       " ISNULL(eqcc.COEFICIENTE,'') as COEFICIENTE,ISNULL(tra.SIMBOLO,'') as SIMBOLO,ISNULL(eqcc.UNIDAD,'') AS unidad"+
                       " from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp inner join"+
                       " ESPECIFICACIONES_QUIMICAS_CC eqcc on eqp.COD_ESPECIFICACION=eqcc.COD_ESPECIFICACION" +
                       " left outer join TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS=eqcc.COD_TIPO_RESULTADO_ANALISIS"+
                       " where eqp.COD_PRODUCTO='"+codComprod+"'  and eqp.ESTADO=1"+
                       (codVersionQuimica>0?" and eqp.COD_VERSION_ESPECIFICACION_PRODUCTO='"+codVersionQuimica+"'":" and eqp.COD_VERSION='"+codVersion+"'")+
                       " group by eqcc.UNIDAD,eqcc.COD_ESPECIFICACION,eqcc.NOMBRE_ESPECIFICACION,eqcc.COD_TIPO_RESULTADO_ANALISIS,eqcc.COEFICIENTE,tra.SIMBOLO";
              System.out.println("consulta especificaciones quimicas "+consulta);
              stdetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);

              res=st.executeQuery(consulta);
              while(res.next())
              {
                  unidad=res.getString("unidad");
                  coeficiente=res.getString("COEFICIENTE");
                  simbolo=res.getString("SIMBOLO");
                  nombreAnalisis=res.getString("NOMBRE_ESPECIFICACION");
                  codEspecificacion=res.getString("COD_ESPECIFICACION");
                  codTipoResultadoAnalisis=res.getString("COD_TIPO_RESULTADO_ANALISIS");
                   consulta="select eqp.DESCRIPCION,eqp.LIMITE_INFERIOR,eqp.LIMITE_SUPERIOR,eqp.VALOR_EXACTO,"+
                           " tr.NOMBRE_REFERENCIACC,raeq.RESULTADO_NUMERICO,"+
                           " isnull(trd.NOMBRE_TIPO_RESULTADO_DESCRIPTIVO,'') as NOMBRE_TIPO_RESULTADO_DESCRIPTIVO,trd.COD_TIPO_RESULTADO_DESCRIPTIVO"+
                           " from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp "+
                           " inner join TIPOS_REFERENCIACC tr on tr.COD_REFERENCIACC=eqp.COD_REFERENCIA_CC"+
                           " inner join RESULTADO_ANALISIS_ESPECIFICACIONES_QUIMICAS raeq on "+
                           " raeq.COD_ESPECIFICACION=eqp.COD_ESPECIFICACION and raeq.COD_MATERIAL=eqp.COD_MATERIAL " +
                           " and raeq.COD_COMPPROD=eqp.COD_PRODUCTO"+
                           " left outer join TIPO_RESULTADO_DESCRIPTIVO trd on trd.COD_TIPO_RESULTADO_DESCRIPTIVO=raeq.COD_TIPO_RESULTADO_DESCRIPTIVO"+
                           " where eqp.COD_ESPECIFICACION='"+codEspecificacion+"'"+
                           (codVersionQuimica>0?" and eqp.COD_VERSION_ESPECIFICACION_PRODUCTO='"+codVersionQuimica+"'":"and eqp.COD_VERSION='"+codVersion+"'")+
                            " and eqp.ESTADO=1"+
                           " and raeq.COD_LOTE='"+codLote+"' and eqp.COD_MATERIAL=-1  and eqp.COD_PRODUCTO='"+codComprod+"'";
                   resdetalle=stdetalle.executeQuery(consulta);
                   if(resdetalle.next())
                   {
                       nombreTipoResultado=resdetalle.getString("NOMBRE_TIPO_RESULTADO_DESCRIPTIVO");
                       nombreReferencia=resdetalle.getString("NOMBRE_REFERENCIACC");
                              limiteInferior=resdetalle.getDouble("LIMITE_INFERIOR");
                              limiteSuperior=resdetalle.getDouble("LIMITE_SUPERIOR");
                              valorExacto=resdetalle.getDouble("VALOR_EXACTO");
                              resultadoNumerico=resdetalle.getDouble("RESULTADO_NUMERICO");
                               nombreEspecificacion=(codTipoResultadoAnalisis.equals("1")?resdetalle.getString("DESCRIPCION"):
                                   (codTipoResultadoAnalisis.equals("2")?(String.valueOf(limiteInferior)+" "+unidad+ "-"+String.valueOf(limiteSuperior)+" "+unidad) :
                                    (coeficiente+" "+(simbolo.equals(">=")?"≥":(simbolo.equals("<=")?"≤":simbolo))+" "+String.valueOf(valorExacto)+" "+unidad)));
                               resultado=(codTipoResultadoAnalisis.equals("1")?nombreTipoResultado:
                                  (nombreTipoResultado.equals("")?(String.valueOf(resultadoNumerico)+" "+unidad):nombreTipoResultado));
                                if(!verificarResultadoAprobar(codTipoResultadoAnalisis, resdetalle.getString("COD_TIPO_RESULTADO_DESCRIPTIVO"),
                                resultadoNumerico, limiteSuperior, limiteInferior, valorExacto))
                                {
                                    aprobado=false;
                                }
                               %>
                            <tr >
                            <td class='border' align='left' ><b><%=nombreAnalisis%></b></td>
                            <td class='border' align='left' ><%=nombreEspecificacion%></td>
                            <td class='border' align='left' ><%=nombreReferencia%></td>
                            <td class='border' align='left' ><%=(resultado)%></td>
                            </tr>
                            <%
                   }
                   else
                   {
                          %>
                          <tr bgcolor="#eeeeee" >
                            <td class='border' align='left' colspan="4" ><b><%=nombreAnalisis%></b></td>
                            </tr>
                          <%
                          consulta="select case when eqp.COD_MATERIAL>0 and eqp.COD_MATERIAL<>-1 then m.NOMBRE_CCC else mcc.NOMBRE_MATERIAL_COMPUESTO_CC end as NOMBRE_CCC," +
                                  " eqp.DESCRIPCION,eqp.LIMITE_INFERIOR,eqp.LIMITE_SUPERIOR,eqp.VALOR_EXACTO,"+
                                   " tr.NOMBRE_REFERENCIACC,raeq.RESULTADO_NUMERICO,"+
                                   " isnull(trd.NOMBRE_TIPO_RESULTADO_DESCRIPTIVO,'') as NOMBRE_TIPO_RESULTADO_DESCRIPTIVO,trd.COD_TIPO_RESULTADO_DESCRIPTIVO"+
                                   " from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp left outer join MATERIALES m on m.COD_MATERIAL=eqp.COD_MATERIAL " +
                                   " left outer join MATERIALES_COMPUESTOS_CC mcc on mcc.COD_MATERIAL_COMPUESTO_CC=eqp.COD_MATERIAL_COMPUESTO_CC" +
                                   " inner join TIPOS_REFERENCIACC tr on tr.COD_REFERENCIACC=eqp.COD_REFERENCIA_CC"+
                                   " inner join RESULTADO_ANALISIS_ESPECIFICACIONES_QUIMICAS raeq on "+
                                   " raeq.COD_ESPECIFICACION=eqp.COD_ESPECIFICACION and raeq.COD_MATERIAL=eqp.COD_MATERIAL and raeq.COD_MATERIAL_COMPUESTO_CC=eqp.COD_MATERIAL_COMPUESTO_CC" +
                                   " and raeq.COD_COMPPROD=eqp.COD_PRODUCTO"+
                                   " left outer join TIPO_RESULTADO_DESCRIPTIVO trd on trd.COD_TIPO_RESULTADO_DESCRIPTIVO=raeq.COD_TIPO_RESULTADO_DESCRIPTIVO"+
                                   " where eqp.COD_ESPECIFICACION='"+codEspecificacion+"'"+
                                  (codVersionQuimica>0?" and eqp.COD_VERSION_ESPECIFICACION_PRODUCTO='"+codVersionQuimica+"'":"  and eqp.COD_VERSION='"+codVersion+"'")+
                                  " and eqp.ESTADO=1"+
                                   " and raeq.COD_LOTE='"+codLote+"' and eqp.COD_PRODUCTO='"+codComprod+"' order by m.NOMBRE_CCC";
                          System.out.println("consulta detalle analisis quimicos "+consulta);

                          resdetalle=stdetalle.executeQuery(consulta);
                          while(resdetalle.next())
                          {
                              nombreTipoResultado=resdetalle.getString("NOMBRE_TIPO_RESULTADO_DESCRIPTIVO");
                              nombreMaterial=resdetalle.getString("NOMBRE_CCC");
                              nombreReferencia=resdetalle.getString("NOMBRE_REFERENCIACC");
                              limiteInferior=resdetalle.getDouble("LIMITE_INFERIOR");
                              limiteSuperior=resdetalle.getDouble("LIMITE_SUPERIOR");
                              valorExacto=resdetalle.getDouble("VALOR_EXACTO");
                              resultadoNumerico=resdetalle.getDouble("RESULTADO_NUMERICO");
                               nombreEspecificacion=(codTipoResultadoAnalisis.equals("1")?resdetalle.getString("DESCRIPCION"):
                                   (codTipoResultadoAnalisis.equals("2")?(String.valueOf(limiteInferior)+" "+unidad+ "-"+String.valueOf(limiteSuperior)+" "+unidad) :
                                    (coeficiente+" "+(simbolo.equals(">=")?"≥":(simbolo.equals("<=")?"≤":simbolo))+" "+String.valueOf(valorExacto)+" "+unidad)));
                               resultado=(codTipoResultadoAnalisis.equals("1")?nombreTipoResultado:
                                (nombreTipoResultado.equals("")?(String.valueOf(resultadoNumerico)+" "+unidad):nombreTipoResultado));
                                if(!verificarResultadoAprobar(codTipoResultadoAnalisis, resdetalle.getString("COD_TIPO_RESULTADO_DESCRIPTIVO"),
                                resultadoNumerico, limiteSuperior, limiteInferior, valorExacto))
                                {
                                    aprobado=false;
                                }
                               %>
                            <tr >
                            <td class='border' align='left' ><%=nombreMaterial%></td>
                            <td class='border' align='left' ><%=nombreEspecificacion%></td>
                            <td class='border' align='left' ><%=nombreReferencia%></td>
                            <td class='border' align='left' ><%=(resultado)%></td>
                            </tr>
                          <%

                          }
                  }
                  resdetalle.close();

              }

              stdetalle.close();
              if(!concentracion.equals(""))
                  {
                          consulta="select m.NOMBRE_CCC,rae.RESULTADO_NUMERICO,cpc.CANTIDAD,um.ABREVIATURA"+
                                  ",cpc.NOMBRE_MATERIAL_EQUIVALENCIA,cpc.CANTIDAD_EQUIVALENCIA,isnull(ume.ABREVIATURA,'') as abreEquivalencia"+
                                    " from RESULTADO_ANALISIS_ESPECIFICACIONES_QUIMICAS rae inner join"+
                                    " materiales m on m.COD_MATERIAL=rae.COD_MATERIAL inner join"+
                                    " COMPONENTES_PROD_CONCENTRACION cpc on cpc.COD_COMPPROD='"+codComprod+"' and "+
                                    " rae.COD_MATERIAL=cpc.COD_MATERIAL and cpc.COD_ESTADO_REGISTRO=1" +
                                    " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=cpc.COD_UNIDAD_MEDIDA"+
                                    " left outer join UNIDADES_MEDIDA ume on ume.COD_UNIDAD_MEDIDA=cpc.COD_UNIDAD_MEDIDA_EQUIVALENCIA"+
                                    " where rae.COD_COMPPROD=cpc.COD_COMPPROD and  rae.COD_ESPECIFICACION=2 and cpc.EXCIPIENTE<>1"+
                                    " and rae.COD_LOTE='"+codLote+"' and rae.COD_TIPO_RESULTADO_DESCRIPTIVO not in (1,2)" +
                                    (codVersionConcentracion>0?" and COD_VERSION_ESPECIFICACION_PRODUCTO ='"+codVersionConcentracion+"' ":" and cpc.COD_VERSION='"+codVersion+"'")+
                                    " order by m.NOMBRE_CCC";
                          System.out.println("consulta concentracion "+consulta);
                          res=st.executeQuery(consulta);
                          String datoQuimico="";

                          while(res.next())
                          {
                              datoQuimico+=(datoQuimico.equals("")?"":"; ")+res.getString("NOMBRE_CCC")+" "+formatoMil.format((res.getDouble("CANTIDAD")/100)*res.getDouble("RESULTADO_NUMERICO"))+" "+res.getString("ABREVIATURA");
                              datoQuimico+=(res.getInt("CANTIDAD_EQUIVALENCIA")>0?(" equivalente a "+res.getString("NOMBRE_MATERIAL_EQUIVALENCIA")+" "+formatoMil.format((res.getDouble("CANTIDAD_EQUIVALENCIA")/100)*res.getDouble("RESULTADO_NUMERICO"))+" "+res.getString("abreEquivalencia")):"");
                          }

                          consulta="select m1.NOMBRE_CCC,m2.NOMBRE_CCC as NOMBRE_CCC2,mcc.COD_MATERIAL_COMPUESTO_CC,"+
                                   " rae.RESULTADO_NUMERICO, cpc1.CANTIDAD,cpc2.CANTIDAD as cantidad2,um1.ABREVIATURA,um2.ABREVIATURA as abreviatura2"+
                                    ",mcc.PORCIENTO_RESULTADO_MATERIAL_1,mcc.PORCIENTO_RESULTADO_MATERIAL_2"+
                                    " from RESULTADO_ANALISIS_ESPECIFICACIONES_QUIMICAS rae inner join MATERIALES_COMPUESTOS_CC mcc"+
                                    " on mcc.COD_MATERIAL_COMPUESTO_CC=rae.COD_MATERIAL_COMPUESTO_CC inner join "+
                                    " materiales m1 on m1.COD_MATERIAL=mcc.COD_MATERIAL_1 inner join"+
                                    " materiales m2 on m2.COD_MATERIAL=mcc.COD_MATERIAL_2 "+
                                    " inner join  COMPONENTES_PROD_CONCENTRACION cpc1 on cpc1.COD_MATERIAL=m1.COD_MATERIAL "+
                                    " inner join COMPONENTES_PROD_CONCENTRACION cpc2 on cpc2.COD_MATERIAL=m2.COD_MATERIAL "+
                                    " inner join UNIDADES_MEDIDA um1 on um1.COD_UNIDAD_MEDIDA=cpc1.COD_UNIDAD_MEDIDA inner join"+
                                    " UNIDADES_MEDIDA um2 on um2.COD_UNIDAD_MEDIDA=cpc2.COD_UNIDAD_MEDIDA"+
                                    " where rae.COD_COMPPROD='"+codComprod+"' and rae.COD_ESPECIFICACION=2 and rae.COD_TIPO_RESULTADO_DESCRIPTIVO not IN(1,2)"+
                                    " and rae.cod_lote='"+codLote+"' and rae.COD_MATERIAL=0 and rae.COD_MATERIAL_COMPUESTO_CC>0"+
                                    " and cpc1.COD_COMPPROD='"+codComprod+"' and cpc2.COD_COMPPROD='"+codComprod+"'" +
                                  (codVersionConcentracion>0?" and cpc1.COD_VERSION_ESPECIFICACION_PRODUCTO='"+codVersionConcentracion+"' and cpc2.COD_VERSION_ESPECIFICACION_PRODUCTO='"+codVersionMicro+"'":
                                    " and cpc1.COD_VERSION='"+codVersion+"' and  cpc2.COD_VERSION='"+codVersion+"'");
                          System.out.println("consulta cargar concentracion materiales compuestos "+consulta);
                          res=st.executeQuery(consulta);
                          while(res.next())
                          {
                              datoQuimico+=(datoQuimico.equals("")?"":"; ")+res.getString("NOMBRE_CCC")+" "+formatoMil.format((res.getDouble("CANTIDAD")*res.getDouble("RESULTADO_NUMERICO"))/100)+" "+res.getString("ABREVIATURA");
                              datoQuimico+=(datoQuimico.equals("")?"":"; ")+res.getString("NOMBRE_CCC2")+" "+formatoMil.format((res.getDouble("CANTIDAD2")*res.getDouble("RESULTADO_NUMERICO"))/100)+" "+res.getString("ABREVIATURA");

                          }
                          if(!datoQuimico.equals(""))
                          {
                            out.println("<tr><td class='border' align='left' colspan='4'>Corresponde a "+datoQuimico+(porUnidadProd.equals("")?"":"/"+porUnidadProd)+"</td></tr>");
                          }
                   }
              %>
             <tr bgcolor="#dddddd">
                    <td class='border' align='center' style='border:1px solid #CCCCCC;padding:8px' colspan="4"><b>ANALISIS MICROBIOLOGICO</b>(Control de Esterilidad)</td>
              </tr>
             <%
             consulta="select em.NOMBRE_ESPECIFICACION,emp.LIMITE_INFERIOR,emp.LIMITE_SUPERIOR,emp.VALOR_EXACTO,emp.DESCRIPCION,tr.NOMBRE_REFERENCIACC,isnull(trd.NOMBRE_TIPO_RESULTADO_DESCRIPTIVO,'') as NOMBRE_TIPO_RESULTADO_DESCRIPTIVO,"+
                      " rae.RESULTADO_NUMERICO,em.COD_TIPO_RESULTADO_ANALISIS,ISNULL(em.COEFICIENTE,'') as COEFICIENTE,ISNULL(tra.SIMBOLO,'') as SIMBOLO,trd.COD_TIPO_RESULTADO_DESCRIPTIVO" +
                      " ,ISNULL(em.unidad,'') as unidad"+
                      " from ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO emp inner join ESPECIFICACIONES_MICROBIOLOGIA em on "+
                      " emp.COD_ESPECIFICACION = em.COD_ESPECIFICACION inner join TIPOS_REFERENCIACC tr on "+
                      " tr.COD_REFERENCIACC = emp.COD_REFERENCIA_CC inner join RESULTADO_ANALISIS_ESPECIFICACIONES rae on"+
                      " rae.COD_TIPO_ANALISIS = 3 and rae.COD_COMPPROD=emp.COD_COMPROD and "+
                      " rae.COD_ESPECIFICACION = emp.COD_ESPECIFICACION left outer JOIN TIPO_RESULTADO_DESCRIPTIVO trd on "+
                      " trd.COD_TIPO_RESULTADO_DESCRIPTIVO=rae.COD_TIPO_RESULTADO_DESCRIPTIVO" +
                      " left outer join TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS=em.COD_TIPO_RESULTADO_ANALISIS"+
                      " where emp.COD_COMPROD = '"+codComprod+"' "+
                      " and rae.COD_LOTE='"+codLote+"'"+
                     (codVersionMicro>0?" and emp.COD_VERSION_ESPECIFICACION_PRODUCTO='"+codVersionMicro+"'":" and emp.COD_VERSION='"+codVersion+"'")+
                      " order by em.NOMBRE_ESPECIFICACION";
             System.out.println("consulta detalle microbiologia "+consulta);
             res=st.executeQuery(consulta);
             
             while(res.next())
                 {
                    nombreTipoResultado=res.getString("NOMBRE_TIPO_RESULTADO_DESCRIPTIVO");
                    unidad=res.getString("unidad");
                    nombreAnalisis=res.getString("NOMBRE_ESPECIFICACION");
                    codTipoResultadoAnalisis=res.getString("COD_TIPO_RESULTADO_ANALISIS");
                    nombreReferencia=res.getString("NOMBRE_REFERENCIACC");
                    limiteInferior=res.getDouble("LIMITE_INFERIOR");
                    limiteSuperior=res.getDouble("LIMITE_SUPERIOR");
                    resultadoNumerico=res.getDouble("RESULTADO_NUMERICO");
                    valorExacto=res.getDouble("VALOR_EXACTO");
                    simbolo=res.getString("SIMBOLO");
                    coeficiente=res.getString("COEFICIENTE");
                    descripcion=res.getString("DESCRIPCION");
                   
                    nombreEspecificacion=(codTipoResultadoAnalisis.equals("1")?descripcion:
                        (codTipoResultadoAnalisis.equals("2")?(String.valueOf(limiteInferior)+" "+unidad+"-"+String.valueOf(limiteSuperior)+" "+unidad):
                        (coeficiente+" "+simbolo+" "+valorExacto+" "+unidad)));
                    resultado=(codTipoResultadoAnalisis.equals("1")?nombreTipoResultado:
                    (nombreTipoResultado.equals("")?(String.valueOf(resultadoNumerico)+" "+unidad):nombreTipoResultado));
                    if(!verificarResultadoAprobar(codTipoResultadoAnalisis,res.getString("COD_TIPO_RESULTADO_DESCRIPTIVO"), resultadoNumerico, limiteSuperior, limiteInferior, valorExacto))
                    {
                        aprobado=false;
                    }
                    conExponente=(descripcion.split("\\^").length>1);
                    
                    
                    %>
                 <tr >
                    <td class='border' align='left'  ><%=nombreAnalisis%></td>
                    <%
                    if(conExponente)
                    {
                        out.println("<td class='border' align='left' ><div style='position:relative;'>"+descripcion.split("\\^")[0]+"<span style='font-size:7px;position:absolute;top:0;rigth:20px'>"+descripcion.split("\\^")[1]+"</span></div></td>");
                        }
                    else
                        {
                            out.println("<td class='border' align='left' >"+nombreEspecificacion+"</td>");
                    }

                    %>
                    
                    <td class='border' align='left' ><%=nombreReferencia%></td>
                    <td class='border' align='left' ><%=resultado%></td>
                   </tr>
                <%
                 }
              
            String observacion="";
            System.out.println(codEstado);
            if(codEstado.equals("1"))
            {
                observacion="Resultado de análisis dentro de los límites";            }
            else
            {
                if(codEstado.equals("2"))
                observacion="Resultado de análisis fuera de los límites";
                else
                    observacion="Resultados sin revisar";
            }
            
             %>
             
            </table>
            <table width="100%" align="center">
                 <tr>
                    <td  align='left' colspan="2"  ><b>OBSERVACIONES:&nbsp;</b><%=observacion%></td>
                    

              </tr>
              <tr>
                    <td  align='left'  ><b>DICTAMEN:&nbsp;<%=dictamen%></b></td>
                    <td  align='left' ><b>Fecha de Emisión:&nbsp;</b><%=sdt.format(fechaEmision)%></td>

              </tr>
              <%--tr>
                    <td  align='left'  ><b>RESULTADOS:&nbsp;</b>Tomo N°<%=tomo%></td>
                    <td  align='left' ><b>PÁGINA:&nbsp;</b><%=pagina%></td>

              </tr--%>
              <tr>
                  
                    <td align='center'><img src="firmasCC/<%=urlFirma%>"></td>
                    <td align='center'><img src="firmasCC/<%=urlFirmaJefeControlDeCalidad%>"></td>
                </tr>
                 <tr>
                    <td  align='center'  ><span class="outputText2"><b>Analista</b></span></td>
                    <td  align='center' ><span class="outputText2"><b>Jefe Control de Calidad:&nbsp;</b></span></td>

                </tr>
                 <tr>
                    <td  align='center'  ><span class="outputText2"><%=nombreAnalista%></span></td>
                    <td  align='center' ><span class="outputText2"><%=nombreJefeControldeCalidad%></span></td>

                </tr>
            </table>
            <%

            res.close();
            st.close();
            con.close();
            }
            catch(SQLException ex)
            {
                ex.printStackTrace();
            }
            %>
            </div>
        </form>
    </body>
</html>
