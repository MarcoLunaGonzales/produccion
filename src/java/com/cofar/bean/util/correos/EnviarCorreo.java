/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean.util.correos;

import com.cofar.util.Util;
import com.sun.net.httpserver.HttpServer;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Locale;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author DASISAQ-
 */
public class EnviarCorreo extends Thread{

    private String codCompProd;
    Connection con=null;
    private int codVersion;
    private String direccion;
    private boolean enviarParaAprobacion;

    public EnviarCorreo(String codCompProd, int codVersion,String direccion,boolean enviarParaAprobacion) {
        this.codCompProd = codCompProd;
        this.codVersion = codVersion;
        this.direccion=direccion;
        this.enviarParaAprobacion=enviarParaAprobacion;
    }
    private String cambioPropuesto()
    {
        StringBuilder innerHTML=new StringBuilder("<table class='tablaComparacion' cellpadding='0' cellspacing='0'>");
                        innerHTML.append("<thead><tr><td colspan='3'>DATOS DEL PRODUCTO</td></tr>");
                        innerHTML.append("<tr><td>Especificación</td><td>Version Activa</td><td>Version Propuesta</td></tr></thead>");
                    try
                    {
                        con=Util.openConnection(con);
                        NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        DecimalFormat formato = (DecimalFormat) numeroformato;
                        formato.applyPattern("#,##0.00");
                        StringBuilder consulta= new StringBuilder("select isnull(cp.COD_COMPPROD,0) as codComprodOfi,isnull(cp.nombre_prod_semiterminado,'') as nombre_prod_semiterminado,cpv.nombre_prod_semiterminado as nombre_prod_semiterminadoVersion");
                        consulta.append(",isnull(ae.NOMBRE_AREA_EMPRESA,'') as NOMBRE_AREA_EMPRESA,ae1.NOMBRE_AREA_EMPRESA as NOMBRE_AREA_EMPRESAVersion");
                        consulta.append(",ISNULL(p.nombre_prod,'')as nombre_prod,p1.nombre_prod as nombre_prodVersion");
                        consulta.append(" ,isnull(cp.NOMBRE_GENERICO,'') as NOMBRE_GENERICO,cpv.NOMBRE_GENERICO as NOMBRE_GENERICOVersion");
                        consulta.append(" ,isnull(ff.nombre_forma,'') as nombre_forma,ff1.nombre_forma as nombre_formaVersion");
                        consulta.append(" ,isnull(cpp.NOMBRE_COLORPRESPRIMARIA,'') as NOMBRE_COLORPRESPRIMARIA,isnull(cpp1.NOMBRE_COLORPRESPRIMARIA,'') as NOMBRE_COLORPRESPRIMARIAVersion");
                        consulta.append(" ,isnull(vap.NOMBRE_VIA_ADMINISTRACION_PRODUCTO,'') as NOMBRE_VIA_ADMINISTRACION_PRODUCTO,isnull(vap1.NOMBRE_VIA_ADMINISTRACION_PRODUCTO,'') as NOMBRE_VIA_ADMINISTRACION_PRODUCTOVersion");
                        consulta.append(" ,isnull(cp.PESO_ENVASE_PRIMARIO,'') as PESO_ENVASE_PRIMARIO,cpv.PESO_ENVASE_PRIMARIO as PESO_ENVASE_PRIMARIOVersion");
                        consulta.append(" ,isnull(cp.TOLERANCIA_VOLUMEN_FABRICAR,0) as TOLERANCIA_VOLUMEN_FABRICAR,isnull(cpv.TOLERANCIA_VOLUMEN_FABRICAR,0) as TOLERANCIA_VOLUMEN_FABRICARVersion");
                        consulta.append(" ,isnull(sp.NOMBRE_SABOR,'') as NOMBRE_SABOR,isnull(sp1.NOMBRE_SABOR,'') as NOMBRE_SABORVersion");
                        consulta.append(" ,isnull(tap.NOMBRE_TAMANIO_CAPSULA_PRODUCCION,'') as NOMBRE_TAMANIO_CAPSULA_PRODUCCION,ISNULL(tap1.NOMBRE_TAMANIO_CAPSULA_PRODUCCION,'') as NOMBRE_TAMANIO_CAPSULA_PRODUCCIONVersion");
                        consulta.append(" ,isnull(ec.NOMBRE_ESTADO_COMPPROD,'') as NOMBRE_ESTADO_COMPPROD,ec1.NOMBRE_ESTADO_COMPPROD as NOMBRE_ESTADO_COMPPRODVersion");
                        consulta.append(" ,isnull(cp.REG_SANITARIO,'') as REG_SANITARIO,cpv.REG_SANITARIO as REG_SANITARIOVersion");
                        consulta.append(" ,isnull(cp.VIDA_UTIL,0) as VIDA_UTIL,cpv.VIDA_UTIL as VIDA_UTILVersion");
                        consulta.append(" ,cp.FECHA_VENCIMIENTO_RS,cpv.FECHA_VENCIMIENTO_RS as FECHA_VENCIMIENTO_RSVersion");
                        consulta.append(" ,isnull(cast(cp.CANTIDAD_VOLUMEN as varchar)+' '+um.ABREVIATURA,'') as volumen");
                        consulta.append(" ,isnull(cast(cpv.CANTIDAD_VOLUMEN as varchar)+' '+um1.ABREVIATURA,'') as volumenVersion");
                        consulta.append(" ,isnull(cp.PRODUCTO_SEMITERMINADO,0) as PRODUCTO_SEMITERMINADO,isnull(cpv.PRODUCTO_SEMITERMINADO,0) as PRODUCTO_SEMITERMINADOVersion");
                        consulta.append(" ,isnull(cvp.NOMBRE_CONDICION_VENTA_PRODUCTO,'') as NOMBRE_CONDICION_VENTA_PRODUCTO,");
                        consulta.append(" isnull(cvp1.NOMBRE_CONDICION_VENTA_PRODUCTO,'') as NOMBRE_CONDICION_VENTA_PRODUCTOVersion,");
                        consulta.append(" isnull(cp.PRESENTACIONES_REGISTRADAS_RS,'') as PRESENTACIONES_REGISTRADAS_RS,");
                        consulta.append(" isnull(cpv.PRESENTACIONES_REGISTRADAS_RS,'') as PRESENTACIONES_REGISTRADAS_RSVersion,");
                        consulta.append(" isnull(cp.NOMBRE_COMERCIAL,'') as NOMBRE_COMERCIAL,isnull(cpv.NOMBRE_COMERCIAL,'') as NOMBRE_COMERCIALVersion");
                        consulta.append(" ,cp.TAMANIO_LOTE_PRODUCCION,cpv.TAMANIO_LOTE_PRODUCCION as TAMANIO_LOTE_PRODUCCIONVersion");
                        consulta.append(" from COMPONENTES_PROD_VERSION cpv left outer join COMPONENTES_PROD cp on cp.COD_COMPPROD=cpv.COD_COMPPROD");
                        consulta.append(" left outer join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=cp.COD_AREA_EMPRESA");
                        consulta.append(" left outer join AREAS_EMPRESA ae1 on ae1.COD_AREA_EMPRESA=cpv.COD_AREA_EMPRESA");
                        consulta.append(" left outer join PRODUCTOS p on p.cod_prod=cp.COD_PROD");
                        consulta.append(" left outer join PRODUCTOS p1 on p1.cod_prod=cpv.COD_PROD");
                        consulta.append(" left outer join FORMAS_FARMACEUTICAS ff on ff.cod_forma=cp.COD_FORMA");
                        consulta.append(" left outer join FORMAS_FARMACEUTICAS ff1 on ff1.cod_forma=cpv.COD_FORMA");
                        consulta.append(" left outer join COLORES_PRESPRIMARIA cpp on cp.COD_COLORPRESPRIMARIA=cpp.COD_COLORPRESPRIMARIA");
                        consulta.append(" left outer join COLORES_PRESPRIMARIA cpp1 on cpv.COD_COLORPRESPRIMARIA=cpp1.COD_COLORPRESPRIMARIA");
                        consulta.append(" left outer join VIAS_ADMINISTRACION_PRODUCTO vap on vap.COD_VIA_ADMINISTRACION_PRODUCTO=cp.COD_VIA_ADMINISTRACION_PRODUCTO");
                        consulta.append(" left outer join VIAS_ADMINISTRACION_PRODUCTO vap1 on vap1.COD_VIA_ADMINISTRACION_PRODUCTO=cpv.COD_VIA_ADMINISTRACION_PRODUCTO");
                        consulta.append(" left outer join SABORES_PRODUCTO sp on sp.COD_SABOR=cp.COD_SABOR");
                        consulta.append(" left outer join SABORES_PRODUCTO sp1 on sp1.COD_SABOR=cpv.COD_SABOR");
                        consulta.append(" left outer join TAMANIOS_CAPSULAS_PRODUCCION tap on tap.COD_TAMANIO_CAPSULA_PRODUCCION=cp.COD_TAMANIO_CAPSULA_PRODUCCION");
                        consulta.append(" left outer join TAMANIOS_CAPSULAS_PRODUCCION tap1 on tap1.COD_TAMANIO_CAPSULA_PRODUCCION=cpv.COD_TAMANIO_CAPSULA_PRODUCCION");
                        consulta.append(" left outer join ESTADOS_COMPPROD ec on ec.COD_ESTADO_COMPPROD=cp.COD_ESTADO_COMPPROD");
                        consulta.append(" left outer join ESTADOS_COMPPROD ec1 on ec1.COD_ESTADO_COMPPROD=cpv.COD_ESTADO_COMPPROD");
                        consulta.append(" left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=cp.COD_UNIDAD_MEDIDA_VOLUMEN");
                        consulta.append(" left outer join UNIDADES_MEDIDA um1 on um1.COD_UNIDAD_MEDIDA=cpv.COD_UNIDAD_MEDIDA_VOLUMEN");
                        consulta.append(" left outer join CONDICIONES_VENTA_PRODUCTO cvp on cvp.COD_CONDICION_VENTA_PRODUCTO=cp.COD_CONDICION_VENTA_PRODUCTO");
                        consulta.append(" left outer join CONDICIONES_VENTA_PRODUCTO cvp1 on cvp1.COD_CONDICION_VENTA_PRODUCTO=cpv.COD_CONDICION_VENTA_PRODUCTO");
                        consulta.append(" where cpv.COD_COMPPROD='").append(codCompProd).append("'");
                        consulta.append(" and cpv.COD_VERSION='").append(codVersion).append("';");
                        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet res=st.executeQuery(consulta.toString());
                        Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet resDetalle=null;
                        boolean nuevo=false;
                        SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
                        boolean productoSemiterminado=false;
                        if(res.next())
                        {
                            productoSemiterminado=res.getInt("PRODUCTO_SEMITERMINADOVersion")>0;
                            nuevo=res.getInt("codComprodOfi")==0;
                            innerHTML.append("<tr class='").append((nuevo?"nuevo":(res.getString("nombre_prod_semiterminado").equals(res.getString("nombre_prod_semiterminadoVersion"))?"":"modificado"))).append("'><td class='especificacion'>Nombre Producto</td><td>").append(res.getString("nombre_prod_semiterminado")).append("&nbsp;</td><td>&nbsp;").append(res.getString("nombre_prod_semiterminadoVersion")).append("</td></tr>");
                            innerHTML.append("<tr class='").append(nuevo?"nuevo":(res.getString("NOMBRE_AREA_EMPRESA").equals(res.getString("NOMBRE_AREA_EMPRESAVersion"))?"":"modificado")).append("'><td class='especificacion'>Area Empresa</td><td>").append(res.getString("NOMBRE_AREA_EMPRESA")).append("&nbsp;</td><td>").append(res.getString("NOMBRE_AREA_EMPRESAVersion")).append("</td></tr>");
                            innerHTML.append("<tr class='").append(nuevo?"nuevo":(res.getString("PRODUCTO_SEMITERMINADO").equals(res.getString("PRODUCTO_SEMITERMINADOVersion"))?"":"modificado")).append("'><td class='especificacion'>Producto Semiterminado</td><td>").append(res.getInt("PRODUCTO_SEMITERMINADO")>0?"SI":"NO").append("</td><td>").append(res.getInt("PRODUCTO_SEMITERMINADOVersion")>0?"SI":"NO").append("</td></tr>");
                            if(!productoSemiterminado)
                            {
                                innerHTML.append("<tr class='").append(nuevo?"nuevo":(res.getString("NOMBRE_COMERCIAL").equals(res.getString("NOMBRE_COMERCIALVersion"))?"":"modificado")).append("'><td class='especificacion'>Nombre Comercial</td><td>&nbsp;").append(res.getString("NOMBRE_COMERCIAL")).append("</td><td>").append(res.getString("NOMBRE_COMERCIALVersion")).append("</td></tr>");
                                innerHTML.append("<tr class='").append(nuevo?"nuevo":(res.getInt("TAMANIO_LOTE_PRODUCCION")==res.getInt("TAMANIO_LOTE_PRODUCCIONVersion")?"":"modificado")).append("'><td class='especificacion'>Tamaño Lote Producción</td><td>&nbsp;").append(res.getInt("TAMANIO_LOTE_PRODUCCION")).append("</td><td>").append(res.getInt("TAMANIO_LOTE_PRODUCCIONVersion")).append("</td></tr>");
                                innerHTML.append("<tr class='").append(nuevo?"nuevo":(res.getString("REG_SANITARIO").equals(res.getString("REG_SANITARIOVersion"))?"":"modificado")).append("'><td class='especificacion'>Registro Sanitario</td><td>&nbsp;").append(res.getString("REG_SANITARIO")).append("</td><td>").append(res.getString("REG_SANITARIOVersion")).append("</td></tr>");
                                innerHTML.append("<tr class='").append(nuevo?"nuevo":(res.getInt("VIDA_UTIL")==res.getInt("VIDA_UTILVersion")?"":"modificado")).append("'><td class='especificacion'>Vida Util</td><td>").append(res.getInt("VIDA_UTIL")).append("</td><td>").append(res.getInt("VIDA_UTILVersion")).append("</td></tr>");
                                innerHTML.append("<tr class='").append(nuevo?"nuevo":(sdfDias.format(res.getTimestamp("FECHA_VENCIMIENTO_RS")).equals(sdfDias.format(res.getTimestamp("FECHA_VENCIMIENTO_RSVersion")))?"":"modificado")).append("'><td class='especificacion'>Fecha Vencimiento R.S.</td><td>").append(res.getTimestamp("FECHA_VENCIMIENTO_RS")!=null?sdfDias.format(res.getTimestamp("FECHA_VENCIMIENTO_RS")):"&nbsp;").append("</td><td>").append(sdfDias.format(res.getTimestamp("FECHA_VENCIMIENTO_RSVersion"))).append("</td></tr>");
                                innerHTML.append("<tr class='").append(nuevo?"nuevo":(res.getString("NOMBRE_SABOR").equals(res.getString("NOMBRE_SABORVersion"))?"":"modificado")).append("'><td class='especificacion'>Sabor</td><td>&nbsp;").append(res.getString("NOMBRE_SABOR")).append("</td><td>&nbsp;").append(res.getString("NOMBRE_SABORVersion")).append("</td></tr>");
                                innerHTML.append("<tr class='").append(nuevo?"nuevo":(res.getString("NOMBRE_CONDICION_VENTA_PRODUCTO").equals(res.getString("NOMBRE_CONDICION_VENTA_PRODUCTOVersion"))?"":"modificado")).append("'><td class='especificacion'>Condición Venta</td><td>&nbsp;").append(res.getString("NOMBRE_CONDICION_VENTA_PRODUCTO")).append("</td><td>&nbsp;").append(res.getString("NOMBRE_CONDICION_VENTA_PRODUCTOVersion")).append("</td></tr>");
                                innerHTML.append("<tr class='").append(nuevo?"nuevo":(res.getString("PRESENTACIONES_REGISTRADAS_RS").equals(res.getString("PRESENTACIONES_REGISTRADAS_RSVersion"))?"":"modificado")).append("'><td class='especificacion'>Presentaciones Registradas</td><td>&nbsp;").append(res.getString("PRESENTACIONES_REGISTRADAS_RS")).append("</td><td>&nbsp;").append(res.getString("PRESENTACIONES_REGISTRADAS_RSVersion")).append("</td></tr>");
                            }
                            innerHTML.append("<tr class='").append(nuevo?"nuevo":(res.getString("nombre_forma").equals(res.getString("nombre_formaVersion"))?"":"modificado")).append("'><td class='especificacion'>Forma Farmaceútica</td><td>&nbsp;").append(res.getString("nombre_forma")).append("</td><td>").append(res.getString("nombre_formaVersion")).append("</td></tr>");
                            innerHTML.append("<tr class='").append(nuevo?"nuevo":(res.getString("NOMBRE_COLORPRESPRIMARIA").equals(res.getString("NOMBRE_COLORPRESPRIMARIAVersion"))?"":"modificado")).append("'><td class='especificacion'>Color Presentación Primaria</td><td> &nbsp;").append(res.getString("NOMBRE_COLORPRESPRIMARIA")).append("</td><td>&nbsp;").append(res.getString("NOMBRE_COLORPRESPRIMARIAVersion")).append("</td></tr>");
                            innerHTML.append("<tr class='").append(nuevo?"nuevo":(res.getString("NOMBRE_VIA_ADMINISTRACION_PRODUCTO").equals(res.getString("NOMBRE_VIA_ADMINISTRACION_PRODUCTOVersion"))?"":"modificado")).append("'><td class='especificacion'>Via Administración</td><td>&nbsp;").append(res.getString("NOMBRE_VIA_ADMINISTRACION_PRODUCTO")).append("</td><td>").append(res.getString("NOMBRE_VIA_ADMINISTRACION_PRODUCTOVersion")).append("</td></tr>");
                            innerHTML.append("<tr class='").append(nuevo?"nuevo":(res.getString("PESO_ENVASE_PRIMARIO").equals(res.getString("PESO_ENVASE_PRIMARIOVersion"))?"":"modificado")).append("'><td class='especificacion'>Peso teorico</td><td>&nbsp;").append(res.getString("PESO_ENVASE_PRIMARIO")).append("</td><td>&nbsp;").append(res.getString("PESO_ENVASE_PRIMARIOVersion")).append("</td></tr>");
                            innerHTML.append("<tr class='").append(nuevo?"nuevo":(res.getDouble("TOLERANCIA_VOLUMEN_FABRICAR")!=res.getDouble("TOLERANCIA_VOLUMEN_FABRICARVersion")?"modificado":"")).append("'><td class='especificacion'>Tolerancia Volumen a Fabricar</td><td>").append(res.getDouble("TOLERANCIA_VOLUMEN_FABRICAR")).append("</td><td>").append(res.getDouble("TOLERANCIA_VOLUMEN_FABRICARVersion")).append("</td></tr>");
                            innerHTML.append("<tr class='").append(nuevo?"nuevo":(res.getString("NOMBRE_TAMANIO_CAPSULA_PRODUCCION").equals(res.getString("NOMBRE_TAMANIO_CAPSULA_PRODUCCIONVersion"))?"":"modificado")).append("'><td class='especificacion'>Tamaño Capsula</td><td>&nbsp;").append(res.getString("NOMBRE_TAMANIO_CAPSULA_PRODUCCION")).append("</td><td>&nbsp;").append(res.getString("NOMBRE_TAMANIO_CAPSULA_PRODUCCIONVersion")).append("</td></tr>");
                            innerHTML.append("<tr class='").append(nuevo?"nuevo":(res.getString("volumen").equals(res.getString("volumenVersion"))?"":"modificado")).append("'><td class='especificacion'>Volumen Envase Primario</td><td>&nbsp;").append(res.getString("volumen")).append("</td><td>&nbsp;").append(res.getString("volumenVersion")).append("</td></tr>");
                            innerHTML.append("<tr class='").append(nuevo?"nuevo":(res.getString("NOMBRE_ESTADO_COMPPROD").equals(res.getString("NOMBRE_ESTADO_COMPPRODVersion"))?"":"modificado")).append("'><td class='especificacion'>Estado</td><td>&nbsp;").append(res.getString("NOMBRE_ESTADO_COMPPROD")).append("</td><td>").append(res.getString("NOMBRE_ESTADO_COMPPRODVersion")).append("</td></tr>");
                      }
                        int codVersionActiva=0;
                        consulta=new StringBuilder("select cpv.COD_VERSION from COMPONENTES_PROD_VERSION cpv where cpv.COD_ESTADO_VERSION=2 and cpv.COD_COMPPROD='").append(codCompProd).append("'");
                        res=st.executeQuery(consulta.toString());
                        if(res.next())codVersionActiva=res.getInt("COD_VERSION");
                        innerHTML.append("</table><table class='tablaComparacion' cellpadding='0' cellspacing='0'>");
                        innerHTML.append("<thead><tr><td colspan='11'>Concentracion</td></tr>");
                        innerHTML.append("<tr><td rowspan=2>Material</td><td colspan='2'>Cantidad</td><td colspan=2>Unidad Medida</td><td colspan=2>Material Equivalencia</td>");
                        innerHTML.append("<td colspan=2>Cantidad Equivalencia</td><td colspan=2>Unidad Medidad<br>Equivalencia</td></tr>");
                        innerHTML.append("<tr><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td></tr></thead>");
                        consulta=new StringBuilder("select m.NOMBRE_MATERIAL,");
                                 consulta.append(" cpc.COD_VERSION,cpc.CANTIDAD,isnull(um.ABREVIATURA,'') as ABREVIATURA,isnull(cpc.NOMBRE_MATERIAL_EQUIVALENCIA,'') as NOMBRE_MATERIAL_EQUIVALENCIA,cpc.CANTIDAD_EQUIVALENCIA,isnull(ume.ABREVIATURA,'') as ABREVIATURAE,");
                                 consulta.append(" cpc1.COD_VERSION as COD_VERSIONVersion,cpc1.CANTIDAD as CANTIDADVersion,isnull(um1.ABREVIATURA,'') as ABREVIATURAVersion,isnull(cpc1.NOMBRE_MATERIAL_EQUIVALENCIA,'') as NOMBRE_MATERIAL_EQUIVALENCIAVersion,cpc1.CANTIDAD_EQUIVALENCIA  as CANTIDAD_EQUIVALENCIAVersion,isnull(ume1.ABREVIATURA,'') as ABREVIATURAEVersion");
                                consulta.append( " from COMPONENTES_PROD_CONCENTRACION cpc full outer join COMPONENTES_PROD_CONCENTRACION cpc1");
                                 consulta.append(" on cpc.COD_MATERIAL=cpc1.COD_MATERIAL");
                                 consulta.append(" and cpc.COD_VERSION='").append(codVersionActiva).append("' and cpc1.COD_VERSION='").append(codVersion).append("'");
                                 consulta.append(" left outer join materiales m on m.COD_MATERIAL=isnull(cpc.COD_MATERIAL,cpc1.COD_MATERIAL)");
                                 consulta.append(" left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=cpc.COD_UNIDAD_MEDIDA");
                                 consulta.append(" left outer join UNIDADES_MEDIDA um1 on um1.COD_UNIDAD_MEDIDA=cpc1.COD_UNIDAD_MEDIDA");
                                 consulta.append(" left outer join UNIDADES_MEDIDA ume on ume.COD_UNIDAD_MEDIDA=cpc.COD_UNIDAD_MEDIDA_EQUIVALENCIA");
                                 consulta.append(" left outer join UNIDADES_MEDIDA ume1 on ume1.COD_UNIDAD_MEDIDA=cpc1.COD_UNIDAD_MEDIDA_EQUIVALENCIA");
                                 consulta.append(" where (cpc.COD_VERSION='").append(codVersionActiva).append("'");
                                 consulta.append(" or cpc1.COD_VERSION='").append(codVersion).append("')");
                                 consulta.append(" order by m.NOMBRE_MATERIAL");
                        
                        res=st.executeQuery(consulta.toString());
                        while(res.next())
                        {
                            innerHTML.append("<tr class='").append(res.getInt("COD_VERSION")==0?"nuevo":(res.getInt("COD_VERSIONVersion")==0?"eliminado":"")).append("'>");
                            innerHTML.append("<td>").append(res.getString("NOMBRE_MATERIAL")).append("</td>");
                            innerHTML.append("<td class='").append((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getDouble("CANTIDAD")==res.getDouble("CANTIDADVersion")?"":"modificado"):"").append("' >&nbsp;").append(res.getDouble("CANTIDAD")).append("</td>");
                            innerHTML.append("<td class='").append((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getDouble("CANTIDAD")==res.getDouble("CANTIDADVersion")?"":"modificado"):"").append("' >&nbsp;").append(res.getDouble("CANTIDADVersion")).append("</td>");
                            innerHTML.append("<td class='").append((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getString("ABREVIATURA").equals(res.getString("ABREVIATURAVersion"))?"":"modificado"):"").append("' >&nbsp;").append(res.getString("ABREVIATURA")).append("</td>");
                            innerHTML.append("<td class='").append((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getString("ABREVIATURA").equals(res.getString("ABREVIATURAVersion"))?"":"modificado"):"").append("' >&nbsp;").append(res.getString("ABREVIATURAVersion")).append("</td>");
                            innerHTML.append("<td class='").append((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getString("NOMBRE_MATERIAL_EQUIVALENCIA").equals(res.getString("NOMBRE_MATERIAL_EQUIVALENCIAVersion"))?"":"modificado"):"").append("' >&nbsp;").append(res.getString("NOMBRE_MATERIAL_EQUIVALENCIA")).append("</td>");
                            innerHTML.append("<td class='").append((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getString("NOMBRE_MATERIAL_EQUIVALENCIA").equals(res.getString("NOMBRE_MATERIAL_EQUIVALENCIAVersion"))?"":"modificado"):"").append("' >&nbsp;").append(res.getString("NOMBRE_MATERIAL_EQUIVALENCIAVersion")).append("</td>");
                            innerHTML.append("<td class='").append((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getDouble("CANTIDAD")==res.getDouble("CANTIDADVersion")?"":"modificado"):"").append("' >&nbsp;").append(res.getDouble("CANTIDAD_EQUIVALENCIA")).append("</td>");
                            innerHTML.append("<td class='").append((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getDouble("CANTIDAD")==res.getDouble("CANTIDADVersion")?"":"modificado"):"").append("' >&nbsp;").append(res.getDouble("CANTIDAD_EQUIVALENCIAVersion")).append("</td>");
                            innerHTML.append("<td class='").append((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getString("ABREVIATURAE").equals(res.getString("ABREVIATURAEVersion"))?"":"modificado"):"").append("' >&nbsp;").append(res.getString("ABREVIATURAE")).append("</td>");
                            innerHTML.append("<td class='").append((res.getInt("COD_VERSION")!=0&&res.getInt("COD_VERSIONVersion")!=0)?(res.getString("ABREVIATURAE").equals(res.getString("ABREVIATURAEVersion"))?"":"modificado"):"").append("' >&nbsp;").append(res.getString("ABREVIATURAEVersion")).append("</td>");
                            innerHTML.append("</tr>");
                        }
                        innerHTML.append("</table><table class='tablaComparacion' cellpadding='0' cellspacing='0'>");
                        innerHTML.append("<thead><tr><td colspan='8'>Presentacion Primaria</td></tr>");
                        innerHTML.append("<tr><td colspan=2>Envase Primario</td><td colspan=2>Cantidad</td><td colspan=2>Tipo Programa Producción</td><td colspan=2>Estado</td></tr>");
                        innerHTML.append("<tr><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td></tr></thead>");
                        consulta=new StringBuilder("select isnull(ep.nombre_envaseprim,'') as nombre_envaseprim,isnull(ep1.nombre_envaseprim,'') as nombre_envaseprimVersion,");
                        consulta.append(" isnull(tpp.NOMBRE_TIPO_PROGRAMA_PROD,'') as NOMBRE_TIPO_PROGRAMA_PROD,isnull(tpp1.NOMBRE_TIPO_PROGRAMA_PROD,'') as NOMBRE_TIPO_PROGRAMA_PRODVersion");
                        consulta.append(" ,isnull(pp.CANTIDAD,0) as CANTIDAD,isnull(ppv.CANTIDAD,0) as CANTIDADVersion");
                        consulta.append(" ,isnull(tpp.NOMBRE_TIPO_PROGRAMA_PROD,'') as NOMBRE_TIPO_PROGRAMA_PROD");
                        consulta.append(" ,isnull(tpp1.NOMBRE_TIPO_PROGRAMA_PROD,'') as NOMBRE_TIPO_PROGRAMA_PRODVersion");
                        consulta.append(" ,isnull(er.NOMBRE_ESTADO_REGISTRO,'') as NOMBRE_ESTADO_REGISTRO");
                        consulta.append(" ,isnull(er1.NOMBRE_ESTADO_REGISTRO,'') as NOMBRE_ESTADO_REGISTROVersion");
                        consulta.append(" ,isnull(pp.COD_PRESENTACION_PRIMARIA,0) as codPresentacionPrimOfi");
                        consulta.append(" ,isnull(ppv.COD_PRESENTACION_PRIMARIA,0) as codPresentacionPrimVer");
                        consulta.append(" from PRESENTACIONES_PRIMARIAS pp full outer join PRESENTACIONES_PRIMARIAS_VERSION ppv");
                        consulta.append(" on pp.COD_PRESENTACION_PRIMARIA=ppv.COD_PRESENTACION_PRIMARIA");
                        consulta.append(" and pp.COD_COMPPROD='").append(codCompProd).append("'");
                        consulta.append(" and ppv.COD_VERSION='").append(codVersion).append("'");
                        consulta.append(" left outer join ENVASES_PRIMARIOS ep on ep.cod_envaseprim=pp.COD_ENVASEPRIM");
                        consulta.append(" left outer join ENVASES_PRIMARIOS ep1 on ep1.cod_envaseprim=ppv.COD_ENVASEPRIM");
                        consulta.append(" left outer join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                        consulta.append(" left outer join TIPOS_PROGRAMA_PRODUCCION tpp1 on tpp1.COD_TIPO_PROGRAMA_PROD=ppv.COD_TIPO_PROGRAMA_PROD");
                        consulta.append(" left outer join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=pp.COD_ESTADO_REGISTRO");
                        consulta.append(" left outer join ESTADOS_REFERENCIALES er1 on er1.COD_ESTADO_REGISTRO=ppv.COD_ESTADO_REGISTRO");
                        consulta.append(" where ( pp.COD_COMPPROD='").append(codCompProd).append("' OR");
                        consulta.append(" ( ppv.COD_COMPPROD = '").append(codCompProd).append("'");
                        consulta.append(" and ppv.COD_VERSION = '").append(codVersion).append("'))");
                        
                        res=st.executeQuery(consulta.toString());
                        while(res.next())
                        {
                            innerHTML.append("<tr class='").append(res.getInt("codPresentacionPrimOfi")==0?"nuevo":(res.getInt("codPresentacionPrimVer")==0?"eliminado":"")).append("'>");
                            innerHTML.append("<td class='").append((res.getInt("codPresentacionPrimOfi")!=0&&res.getInt("codPresentacionPrimVer")!=0)?(res.getString("nombre_envaseprim").equals(res.getString("nombre_envaseprimVersion"))?"":"modificado"):"").append("' >&nbsp;").append(res.getString("nombre_envaseprim")).append("</td>");
                            innerHTML.append("<td class='").append((res.getInt("codPresentacionPrimOfi")!=0&&res.getInt("codPresentacionPrimVer")!=0)?(res.getString("nombre_envaseprim").equals(res.getString("nombre_envaseprimVersion"))?"":"modificado"):"").append("' >&nbsp;").append(res.getString("nombre_envaseprimVersion")).append("</td>");
                            innerHTML.append("<td class='").append((res.getInt("codPresentacionPrimOfi")!=0&&res.getInt("codPresentacionPrimVer")!=0)?(res.getInt("CANTIDAD")!=res.getInt("CANTIDADVersion")?"modificado":""):"").append("'>&nbsp;").append((res.getInt("CANTIDAD")>0?res.getInt("CANTIDAD"):"")).append("</td>");
                            innerHTML.append("<td class='").append((res.getInt("codPresentacionPrimOfi")!=0&&res.getInt("codPresentacionPrimVer")!=0)?(res.getInt("CANTIDAD")!=res.getInt("CANTIDADVersion")?"modificado":""):"").append("'>&nbsp;").append((res.getInt("CANTIDADVersion")>0?res.getInt("CANTIDADVersion"):"")).append("</td>");
                            innerHTML.append("<td class='").append((res.getInt("codPresentacionPrimOfi")!=0&&res.getInt("codPresentacionPrimVer")!=0)?(res.getString("NOMBRE_TIPO_PROGRAMA_PROD").equals(res.getString("NOMBRE_TIPO_PROGRAMA_PRODVersion"))?"":"modificado"):"").append("' >&nbsp;").append(res.getString("NOMBRE_TIPO_PROGRAMA_PROD")).append("</td>");
                            innerHTML.append("<td class='").append((res.getInt("codPresentacionPrimOfi")!=0&&res.getInt("codPresentacionPrimVer")!=0)?(res.getString("NOMBRE_TIPO_PROGRAMA_PROD").equals(res.getString("NOMBRE_TIPO_PROGRAMA_PRODVersion"))?"":"modificado"):"").append("' >&nbsp;").append(res.getString("NOMBRE_TIPO_PROGRAMA_PRODVersion")).append("</td>");
                            innerHTML.append("<td class='").append((res.getInt("codPresentacionPrimOfi")!=0&&res.getInt("codPresentacionPrimVer")!=0)?(res.getString("NOMBRE_ESTADO_REGISTRO").equals(res.getString("NOMBRE_ESTADO_REGISTROVersion"))?"":"modificado"):"").append("' >&nbsp;").append(res.getString("NOMBRE_ESTADO_REGISTRO")).append("</td>");
                            innerHTML.append("<td class='").append((res.getInt("codPresentacionPrimOfi")!=0&&res.getInt("codPresentacionPrimVer")!=0)?(res.getString("NOMBRE_ESTADO_REGISTRO").equals(res.getString("NOMBRE_ESTADO_REGISTROVersion"))?"":"modificado"):"").append("'>&nbsp;").append(res.getString("NOMBRE_ESTADO_REGISTROVersion")).append("</td>");
                            innerHTML.append("</tr>");
                        }
                        innerHTML.append("</table><table class='tablaComparacion' cellpadding='0' cellspacing='0'>");
                        innerHTML.append("<thead><tr><td colspan='8'>Presentaciones Secundarias</td></tr>");
                        innerHTML.append("<tr><td colspan=2>Presentación Secundaria</td><td colspan=2>Cantidad</td><td colspan=2>Tipo Programa Producción</td><td colspan=2>Estado</td></tr>");
                        innerHTML.append("<tr><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td></tr></thead>");
                        consulta=new StringBuilder("select cpp.COD_TIPO_PROGRAMA_PROD as codVersionOficial,isnull(cpv.COD_VERSION,0) as codVersion,isnull(tpp.NOMBRE_TIPO_PROGRAMA_PROD,'') as NOMBRE_TIPO_PROGRAMA_PROD");
                        consulta.append(" ,isnull(tpp1.NOMBRE_TIPO_PROGRAMA_PROD,'') as NOMBRE_TIPO_PROGRAMA_PRODVersion");
                        consulta.append(" ,isnull(pp.NOMBRE_PRODUCTO_PRESENTACION,'') as NOMBRE_PRODUCTO_PRESENTACION");
                        consulta.append(" ,isnull(pp1.NOMBRE_PRODUCTO_PRESENTACION,'') as NOMBRE_PRODUCTO_PRESENTACIONVersion");
                        consulta.append(" ,isnull(er.NOMBRE_ESTADO_REGISTRO,'') as NOMBRE_ESTADO_REGISTRO");
                        consulta.append(" ,isnull(er1.NOMBRE_ESTADO_REGISTRO,'') as NOMBRE_ESTADO_REGISTROVersion");
                        consulta.append(" ,cpp.CANT_COMPPROD,cpv.CANT_COMPPROD as CANT_COMPPRODVersion");
                        consulta.append(" from COMPONENTES_PRESPROD cpp full outer join COMPONENTES_PRESPROD_VERSION cpv on");
                        consulta.append(" cpp.COD_PRESENTACION=cpv.COD_PRESENTACION and cpp.COD_COMPPROD=cpv.COD_COMPPROD");
                        consulta.append(" and cpp.COD_TIPO_PROGRAMA_PROD=cpv.COD_TIPO_PROGRAMA_PROD");
                        consulta.append(" and cpp.COD_COMPPROD='").append(codCompProd).append("'");
                        consulta.append(" and cpv.COD_VERSION='").append(codVersion).append("'");
                        consulta.append(" left outer join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=cpp.COD_TIPO_PROGRAMA_PROD");
                        consulta.append(" left outer join TIPOS_PROGRAMA_PRODUCCION tpp1 on tpp1.COD_TIPO_PROGRAMA_PROD=cpv.COD_TIPO_PROGRAMA_PROD");
                        consulta.append(" left outer join PRESENTACIONES_PRODUCTO pp on pp.cod_presentacion=cpp.COD_PRESENTACION");
                        consulta.append(" left outer join PRESENTACIONES_PRODUCTO pp1 on pp1.cod_presentacion=cpv.COD_PRESENTACION");
                        consulta.append(" left outer join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=cpp.COD_ESTADO_REGISTRO");
                        consulta.append(" left outer join ESTADOS_REFERENCIALES er1 on er1.COD_ESTADO_REGISTRO=cpv.COD_ESTADO_REGISTRO");
                        consulta.append(" where(cpp.COD_COMPPROD='").append(codCompProd).append("' or");
                        consulta.append(" (cpv.COD_COMPPROD='").append(codCompProd).append("'");
                        consulta.append(" and cpv.COD_VERSION='").append(codVersion).append("'))");
                        
                        res=st.executeQuery(consulta.toString());

                        while(res.next())
                        {
                            innerHTML.append("<tr class='").append(res.getInt("codVersionOficial")==0?"nuevo":(res.getInt("codVersion")==0?"eliminado":"")).append("'>");
                            innerHTML.append("<td class='").append(res.getInt("codVersion")!=0&&res.getInt("codVersionOficial")!=0?(res.getString("NOMBRE_PRODUCTO_PRESENTACION").equals(res.getString("NOMBRE_PRODUCTO_PRESENTACIONVersion"))?"":"modificado"):"").append("' >&nbsp;").append(res.getString("NOMBRE_PRODUCTO_PRESENTACION")).append("</td>");
                            innerHTML.append("<td class='").append(res.getInt("codVersion")!=0&&res.getInt("codVersionOficial")!=0?(res.getString("NOMBRE_PRODUCTO_PRESENTACION").equals(res.getString("NOMBRE_PRODUCTO_PRESENTACIONVersion"))?"":"modificado"):"").append("' >&nbsp;").append(res.getString("NOMBRE_PRODUCTO_PRESENTACIONVersion")).append("</td>");
                            innerHTML.append("<td class='").append(res.getInt("codVersion")!=0&&res.getInt("codVersionOficial")!=0?(res.getInt("CANT_COMPPROD")!=res.getInt("CANT_COMPPRODVersion")?"modificado":""):"").append("' >&nbsp;").append(res.getInt("CANT_COMPPROD")).append("</td>");
                            innerHTML.append("<td class='").append(res.getInt("codVersion")!=0&&res.getInt("codVersionOficial")!=0?(res.getInt("CANT_COMPPROD")!=res.getInt("CANT_COMPPRODVersion")?"modificado":""):"").append("' >&nbsp;").append(res.getInt("CANT_COMPPRODVersion")).append("</td>");
                            innerHTML.append("<td class='").append(res.getInt("codVersion")!=0&&res.getInt("codVersionOficial")!=0?(res.getString("NOMBRE_TIPO_PROGRAMA_PROD").equals(res.getString("NOMBRE_TIPO_PROGRAMA_PRODVersion"))?"":"modificado"):"").append("' >&nbsp;").append(res.getString("NOMBRE_TIPO_PROGRAMA_PROD")).append("</td>");
                            innerHTML.append("<td class='").append(res.getInt("codVersion")!=0&&res.getInt("codVersionOficial")!=0?(res.getString("NOMBRE_TIPO_PROGRAMA_PROD").equals(res.getString("NOMBRE_TIPO_PROGRAMA_PRODVersion"))?"":"modificado"):"").append("' >&nbsp;").append(res.getString("NOMBRE_TIPO_PROGRAMA_PRODVersion")).append("</td>");
                            innerHTML.append("<td class='").append(res.getInt("codVersion")!=0&&res.getInt("codVersionOficial")!=0?(res.getString("NOMBRE_ESTADO_REGISTRO").equals(res.getString("NOMBRE_ESTADO_REGISTROVersion"))?"":"modificado"):"").append("' >&nbsp;").append(res.getString("NOMBRE_ESTADO_REGISTRO")).append("</td>");
                            innerHTML.append("<td class='").append(res.getInt("codVersion")!=0&&res.getInt("codVersionOficial")!=0?(res.getString("NOMBRE_ESTADO_REGISTRO").equals(res.getString("NOMBRE_ESTADO_REGISTROVersion"))?"":"modificado"):"").append("' >&nbsp;").append(res.getString("NOMBRE_ESTADO_REGISTROVersion")).append("</td>");
                            innerHTML.append("</tr>");
                        }

                        innerHTML.append("</table><table class='tablaComparacion' cellpadding='0' cellspacing='0'>");
                        innerHTML.append("<thead><tr><td colspan='6'>Especificaciones Fisicas de Control de Calidad</td></tr>");
                        innerHTML.append("<tr><td rowspan=2>Analisis Físico</td><td colspan=2>Especificación</td>");
                        innerHTML.append("<td colspan=2>Tipo de Referencia</td><td rowspan='2'>Unidad</td></tr>");
                        innerHTML.append("<tr><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td></tr></thead>");
                        consulta=new StringBuilder("select efc.NOMBRE_ESPECIFICACION,efc.COEFICIENTE,ISNULL(efc.UNIDAD,'') AS UNIDAD,tra.NOMBRE_TIPO_RESULTADO_ANALISIS,tra.COD_TIPO_RESULTADO_ANALISIS,tra.SIMBOLO");
                         consulta.append(" ,efp.COD_ESPECIFICACION,efp.LIMITE_INFERIOR,efp.LIMITE_SUPERIOR,efp.VALOR_EXACTO,isnull(efp.DESCRIPCION,'') as DESCRIPCION,efp.COD_REFERENCIA_CC,isnull(tr.NOMBRE_REFERENCIACC,'') as NOMBRE_REFERENCIACC");
                         consulta.append(" ,efp1.COD_ESPECIFICACION as COD_ESPECIFICACIONVersion,efp1.LIMITE_INFERIOR as LIMITE_INFERIORVersion,efp1.LIMITE_SUPERIOR as LIMITE_SUPERIORVersion,efp1.VALOR_EXACTO AS VALOR_EXACTOVersion,isnull(efp1.DESCRIPCION,'') as DESCRIPCIONVersion,efp1.COD_REFERENCIA_CC,isnull(tr1.NOMBRE_REFERENCIACC,'') as NOMBRE_REFERENCIACCVersion");
                         consulta.append(" from ESPECIFICACIONES_FISICAS_PRODUCTO efp ");
                         consulta.append(" full outer join ESPECIFICACIONES_FISICAS_PRODUCTO efp1 on");
                         consulta.append(" efp.COD_ESPECIFICACION=efp1.COD_ESPECIFICACION");
                         consulta.append(" and efp.COD_VERSION='").append(codVersionActiva).append("' and efp1.COD_VERSION='").append(codVersion).append("'");
                         consulta.append(" left outer join ESPECIFICACIONES_FISICAS_CC efc on (");
                         consulta.append(" efc.COD_ESPECIFICACION=efp.COD_ESPECIFICACION or efp1.COD_ESPECIFICACION=efc.COD_ESPECIFICACION)");
                         consulta.append(" left outer join TIPOS_REFERENCIACC tr on tr.COD_REFERENCIACC=efp.COD_REFERENCIA_CC");
                         consulta.append(" left outer join TIPOS_REFERENCIACC tr1 on tr1.COD_REFERENCIACC=efp1.COD_REFERENCIA_CC");
                         consulta.append(" left outer join TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS=efc.COD_TIPO_RESULTADO_ANALISIS");
                         consulta.append(" where (efp.COD_VERSION='").append(codVersionActiva).append("' or efp1.COD_VERSION='").append(codVersion).append("')");
                         consulta.append(" order by efc.NOMBRE_ESPECIFICACION");
                        
                        res=st.executeQuery(consulta.toString());
                        String especificacion="";
                        String especificacionVersion="";
                        while(res.next())
                        {
                            switch(res.getInt("COD_TIPO_RESULTADO_ANALISIS"))
                            {
                                case 1:
                                {
                                    especificacion=res.getString("DESCRIPCION");
                                    especificacionVersion=res.getString("DESCRIPCIONVersion");
                                    break;
                                }
                                case 2:
                                {
                                    especificacion=res.getDouble("LIMITE_INFERIOR")+" "+res.getString("UNIDAD")+"-"+res.getDouble("LIMITE_SUPERIOR")+" "+res.getString("UNIDAD");
                                    especificacionVersion=res.getDouble("LIMITE_INFERIORVersion")+" "+res.getString("UNIDAD")+"-"+res.getDouble("LIMITE_SUPERIORVersion")+" "+res.getString("UNIDAD");
                                    break;
                                }
                                default:
                                {
                                    especificacion=res.getString("COEFICIENTE")+res.getString("SIMBOLO")+" "+res.getDouble("VALOR_EXACTO")+" "+res.getString("UNIDAD");
                                    especificacionVersion=res.getString("COEFICIENTE")+res.getString("SIMBOLO")+" "+res.getDouble("VALOR_EXACTOVersion")+" "+res.getString("UNIDAD");

                                }
                            }
                            innerHTML.append("<tr class='").append(res.getInt("COD_ESPECIFICACION")==0?"nuevo":(res.getInt("COD_ESPECIFICACIONVersion")==0?"eliminado":"")).append("'>");
                            innerHTML.append("<td>&nbsp;").append(res.getString("NOMBRE_ESPECIFICACION")).append("</td>");
                            innerHTML.append("<td class='").append(res.getInt("COD_ESPECIFICACION")!=0&&res.getInt("COD_ESPECIFICACIONVersion")!=0?(especificacion.equals(especificacionVersion)?"":"modificado"):"").append("' >&nbsp;").append(especificacion).append("</td>");
                            innerHTML.append("<td class='").append(res.getInt("COD_ESPECIFICACION")!=0&&res.getInt("COD_ESPECIFICACIONVersion")!=0?(especificacion.equals(especificacionVersion)?"":"modificado"):"").append("' >&nbsp;").append(especificacionVersion).append("</td>");
                            innerHTML.append("<td class='").append(res.getInt("COD_ESPECIFICACION")!=0&&res.getInt("COD_ESPECIFICACIONVersion")!=0?(res.getString("NOMBRE_REFERENCIACC").equals(res.getString("NOMBRE_REFERENCIACCVersion"))?"":"modificado"):"").append("' >&nbsp;").append(res.getString("NOMBRE_REFERENCIACC")).append("</td>");
                            innerHTML.append("<td class='").append(res.getInt("COD_ESPECIFICACION")!=0&&res.getInt("COD_ESPECIFICACIONVersion")!=0?(res.getString("NOMBRE_REFERENCIACC").equals(res.getString("NOMBRE_REFERENCIACCVersion"))?"":"modificado"):"").append("' >&nbsp;").append(res.getString("NOMBRE_REFERENCIACCVersion")).append("</td>");
                            innerHTML.append("<td>&nbsp;").append(res.getString("UNIDAD")).append("</td>");
                            innerHTML.append("</tr>");
                        }
                        innerHTML.append("</table><table class='tablaComparacion' cellpadding='0' cellspacing='0'>");
                        innerHTML.append("<thead><tr><td colspan='6'>Especificaciones Quimicas de Control de Calidad</td></tr>");
                        innerHTML.append("<tr><td rowspan=2>Analisis Quimico</td><td colspan=2>Especificación</td>");
                        innerHTML.append("<td colspan=2>Tipo de Referencia</td><td rowspan='2'>Unidad</td></tr>");
                        innerHTML.append("<tr><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td></tr></thead>");
                        consulta=new StringBuilder("select eqc.COD_ESPECIFICACION,eqc.NOMBRE_ESPECIFICACION,eqc.COD_TIPO_RESULTADO_ANALISIS,ISNULL(eqc.COEFICIENTE, '') as COEFICIENTE,");
                         consulta.append(" ISNULL(tra.SIMBOLO, '') as SIMBOLO,ISNULL(eqc.UNIDAD, '') AS unidad");
                         consulta.append(" from ESPECIFICACIONES_QUIMICAS_CC eqc left outer join TIPOS_RESULTADOS_ANALISIS tra");
                         consulta.append(" on eqc.COD_TIPO_RESULTADO_ANALISIS=tra.COD_TIPO_RESULTADO_ANALISIS");
                         consulta.append(" where (eqc.COD_ESPECIFICACION in (select eqp.COD_ESPECIFICACION from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp where eqp.COD_VERSION='").append(codVersionActiva).append("')");
                         consulta.append(" or eqc.COD_ESPECIFICACION in (select eqp1.COD_ESPECIFICACION from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp1 where eqp1.COD_VERSION='").append(codVersion).append("'))");
                         consulta.append(" order by eqc.NOMBRE_ESPECIFICACION");
                        
                        res=st.executeQuery(consulta.toString());
                        while(res.next())
                        {
                            innerHTML.append("<tr><td class='celdaQuimica' colspan='6'>").append(res.getString("NOMBRE_ESPECIFICACION")).append("</td></tr>");
                            consulta=new StringBuilder("select isnull(m.NOMBRE_MATERIAL,'ESPECIFICACION GENERAL') as NOMBRE_MATERIAL");
                             consulta.append(" ,eqp.COD_ESPECIFICACION,eqp.VALOR_EXACTO,eqp.LIMITE_INFERIOR,eqp.LIMITE_SUPERIOR,isnull(eqp.DESCRIPCION,'') as DESCRIPCION,isnull(tr.NOMBRE_REFERENCIACC,'') as NOMBRE_REFERENCIACC,");
                             consulta.append(" eqp1.COD_ESPECIFICACION as COD_ESPECIFICACIONVersion,eqp1.VALOR_EXACTO as VALOR_EXACTOVersion,eqp1.LIMITE_INFERIOR as LIMITE_INFERIORVersion");
                             consulta.append(",eqp1.LIMITE_SUPERIOR as LIMITE_SUPERIORVersion,isnull(eqp1.DESCRIPCION,'') as  DESCRIPCIONVersion,isnull(tr1.NOMBRE_REFERENCIACC,'') as NOMBRE_REFERENCIACCVersion");
                             consulta.append(" from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp ");
                             consulta.append(" full outer join ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp1 on");
                             consulta.append(" eqp.COD_ESPECIFICACION=eqp1.COD_ESPECIFICACION");
                             consulta.append(" and eqp.COD_VERSION='").append(codVersionActiva).append("' and eqp1.COD_VERSION='").append(codVersion).append("'");
                             consulta.append(" and eqp.COD_MATERIAL=eqp1.COD_MATERIAL");
                             consulta.append(" left outer join TIPOS_REFERENCIACC tr on tr.COD_REFERENCIACC=eqp.COD_REFERENCIA_CC");
                             consulta.append(" left outer join TIPOS_REFERENCIACC tr1 on tr1.COD_REFERENCIACC=eqp1.COD_REFERENCIA_CC");
                             consulta.append(" left outer join MATERIALES m on (m.COD_MATERIAL=eqp.COD_MATERIAL or m.COD_MATERIAL=eqp1.COD_MATERIAL)");
                             consulta.append(" where ((eqp.COD_VERSION='").append(codVersionActiva).append("' and eqp.COD_ESPECIFICACION='").append(res.getInt("COD_ESPECIFICACION")).append("')");
                             consulta.append(" or (eqp1.COD_VERSION='").append(codVersion).append("'");
                             consulta.append(" and eqp1.COD_ESPECIFICACION='").append(res.getInt("COD_ESPECIFICACION")).append("'))");
                             consulta.append(" order by m.NOMBRE_MATERIAL");
                            
                            resDetalle=stDetalle.executeQuery(consulta.toString());
                            while(resDetalle.next())
                            {
                                switch(res.getInt("COD_TIPO_RESULTADO_ANALISIS"))
                                {
                                    case 1:
                                    {
                                        especificacion=resDetalle.getString("DESCRIPCION");
                                        especificacionVersion=resDetalle.getString("DESCRIPCIONVersion");
                                        break;
                                    }
                                    case 2:
                                    {
                                        especificacion=resDetalle.getDouble("LIMITE_INFERIOR")+" "+res.getString("UNIDAD")+"-"+resDetalle.getDouble("LIMITE_SUPERIOR")+" "+res.getString("UNIDAD");
                                        especificacionVersion=resDetalle.getDouble("LIMITE_INFERIORVersion")+" "+res.getString("UNIDAD")+"-"+resDetalle.getDouble("LIMITE_SUPERIORVersion")+" "+res.getString("UNIDAD");
                                        break;
                                    }
                                    default:
                                    {
                                        especificacion=res.getString("COEFICIENTE")+res.getString("SIMBOLO")+" "+resDetalle.getDouble("VALOR_EXACTO")+" "+res.getString("UNIDAD");
                                        especificacionVersion=res.getString("COEFICIENTE")+res.getString("SIMBOLO")+" "+resDetalle.getDouble("VALOR_EXACTOVersion")+" "+res.getString("UNIDAD");

                                    }
                                }
                                innerHTML.append("<tr class='").append(resDetalle.getInt("COD_ESPECIFICACION")==0?"nuevo":(resDetalle.getInt("COD_ESPECIFICACIONVersion")==0?"eliminado":"")).append("'>");
                                innerHTML.append("<td>&nbsp;").append(resDetalle.getString("NOMBRE_MATERIAL")).append("</td>");
                                innerHTML.append("<td class='").append(resDetalle.getInt("COD_ESPECIFICACION")!=0&&resDetalle.getInt("COD_ESPECIFICACIONVersion")!=0?(especificacion.equals(especificacionVersion)?"":"modificado"):"").append("' >&nbsp;").append(especificacion).append("</td>");
                                innerHTML.append("<td class='").append(resDetalle.getInt("COD_ESPECIFICACION")!=0&&resDetalle.getInt("COD_ESPECIFICACIONVersion")!=0?(especificacion.equals(especificacionVersion)?"":"modificado"):"").append("' >&nbsp;").append(especificacionVersion).append("</td>");
                                innerHTML.append("<td class='").append(resDetalle.getInt("COD_ESPECIFICACION")!=0&&resDetalle.getInt("COD_ESPECIFICACIONVersion")!=0?(resDetalle.getString("NOMBRE_REFERENCIACC").equals(resDetalle.getString("NOMBRE_REFERENCIACCVersion"))?"":"modificado"):"").append("' >&nbsp;").append(resDetalle.getString("NOMBRE_REFERENCIACC")).append("</td>");
                                innerHTML.append("<td class='").append(resDetalle.getInt("COD_ESPECIFICACION")!=0&&resDetalle.getInt("COD_ESPECIFICACIONVersion")!=0?(resDetalle.getString("NOMBRE_REFERENCIACC").equals(resDetalle.getString("NOMBRE_REFERENCIACCVersion"))?"":"modificado"):"").append("' >&nbsp;").append(resDetalle.getString("NOMBRE_REFERENCIACCVersion")).append("</td>");
                                innerHTML.append("<td>&nbsp;").append(res.getString("UNIDAD")).append("</td>");
                                innerHTML.append("</tr>");
                            }
                        }
                        innerHTML.append("</table><table class='tablaComparacion' cellpadding='0' cellspacing='0'>");
                        innerHTML.append("<thead><tr><td colspan='6'>Especificaciones Microbiologicas de Control de Calidad</td></tr>");
                        innerHTML.append("<tr><td rowspan=2>Analisis Microbiológico</td><td colspan=2>Especificación</td>");
                        innerHTML.append("<td colspan=2>Tipo de Referencia</td><td rowspan='2'>Unidad</td></tr>");
                        innerHTML.append("<tr><td>Antes</td><td>Despues</td><td>Antes</td><td>Despues</td></tr></thead>");
                        consulta=new StringBuilder("select em.NOMBRE_ESPECIFICACION,em.COEFICIENTE,ISNULL(em.UNIDAD,'') as UNIDAD,tra.COD_TIPO_RESULTADO_ANALISIS,tra.SIMBOLO,");
                         consulta.append(" emp.COD_ESPECIFICACION,emp.VALOR_EXACTO,emp.LIMITE_INFERIOR,emp.LIMITE_SUPERIOR,isnull(emp.DESCRIPCION,'') as DESCRIPCION,isnull(tr.NOMBRE_REFERENCIACC,'') as NOMBRE_REFERENCIACC,");
                         consulta.append(" emp1.COD_ESPECIFICACION as COD_ESPECIFICACIONVersion,emp1.VALOR_EXACTO as VALOR_EXACTOVersion,emp1.LIMITE_INFERIOR as LIMITE_INFERIORVersion,emp1.LIMITE_SUPERIOR as LIMITE_SUPERIORVersion,ISNULL(emp1.DESCRIPCION,'') as DESCRIPCIONVersion,isnull(tr1.NOMBRE_REFERENCIACC,'') as NOMBRE_REFERENCIACCVersion");
                         consulta.append(" from ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO emp full outer join");
                         consulta.append(" ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO emp1 on emp.COD_ESPECIFICACION=emp1.COD_ESPECIFICACION");
                         consulta.append(" and emp.COD_VERSION='").append(codVersionActiva).append("' and emp1.COD_VERSION='").append(codVersion).append("'");
                         consulta.append(" left outer join ESPECIFICACIONES_MICROBIOLOGIA em on");
                         consulta.append(" (em.COD_ESPECIFICACION=emp.COD_ESPECIFICACION or em.COD_ESPECIFICACION=emp1.COD_ESPECIFICACION)");
                         consulta.append(" left outer join TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS=em.COD_TIPO_RESULTADO_ANALISIS");
                         consulta.append(" left outer join TIPOS_REFERENCIACC tr on tr.COD_REFERENCIACC=emp.COD_REFERENCIA_CC");
                         consulta.append(" left outer join TIPOS_REFERENCIACC tr1 on tr1.COD_REFERENCIACC=emp1.COD_REFERENCIA_CC");
                         consulta.append(" where (emp.COD_VERSION='").append(codVersionActiva).append("' or emp1.COD_VERSION='").append(codVersion).append("')");
                         consulta.append(" order by em.NOMBRE_ESPECIFICACION");
                        
                        res=st.executeQuery(consulta.toString());
                        while(res.next())
                        {
                            switch(res.getInt("COD_TIPO_RESULTADO_ANALISIS"))
                            {
                                case 1:
                                {
                                    especificacion=res.getString("DESCRIPCION");
                                    especificacionVersion=res.getString("DESCRIPCIONVersion");
                                    break;
                                }
                                case 2:
                                {
                                    especificacion=res.getDouble("LIMITE_INFERIOR")+" "+res.getString("UNIDAD")+"-"+res.getDouble("LIMITE_SUPERIOR")+" "+res.getString("UNIDAD");
                                    especificacionVersion=res.getDouble("LIMITE_INFERIORVersion")+" "+res.getString("UNIDAD")+"-"+res.getDouble("LIMITE_SUPERIORVersion")+" "+res.getString("UNIDAD");
                                    break;
                                }
                                default:
                                {
                                    especificacion=res.getString("COEFICIENTE")+res.getString("SIMBOLO")+" "+res.getDouble("VALOR_EXACTO")+" "+res.getString("UNIDAD");
                                    especificacionVersion=res.getString("COEFICIENTE")+res.getString("SIMBOLO")+" "+res.getDouble("VALOR_EXACTOVersion")+" "+res.getString("UNIDAD");

                                }
                            }
                            innerHTML.append("<tr class='").append(res.getInt("COD_ESPECIFICACION")==0?"nuevo":(res.getInt("COD_ESPECIFICACIONVersion")==0?"eliminado":"")).append("'>");
                            innerHTML.append("<td>&nbsp;").append(res.getString("NOMBRE_ESPECIFICACION")).append("</td>");
                            innerHTML.append("<td class='").append(res.getInt("COD_ESPECIFICACION")!=0&&res.getInt("COD_ESPECIFICACIONVersion")!=0?(especificacion.equals(especificacionVersion)?"":"modificado"):"").append("' >&nbsp;").append(especificacion).append("</td>");
                            innerHTML.append("<td class='").append(res.getInt("COD_ESPECIFICACION")!=0&&res.getInt("COD_ESPECIFICACIONVersion")!=0?(especificacion.equals(especificacionVersion)?"":"modificado"):"").append("' >&nbsp;").append(especificacionVersion).append("</td>");
                            innerHTML.append("<td class='").append(res.getInt("COD_ESPECIFICACION")!=0&&res.getInt("COD_ESPECIFICACIONVersion")!=0?(res.getString("NOMBRE_REFERENCIACC").equals(res.getString("NOMBRE_REFERENCIACCVersion"))?"":"modificado"):"").append("' >&nbsp;").append(res.getString("NOMBRE_REFERENCIACC")).append("</td>");
                            innerHTML.append("<td class='").append(res.getInt("COD_ESPECIFICACION")!=0&&res.getInt("COD_ESPECIFICACIONVersion")!=0?(res.getString("NOMBRE_REFERENCIACC").equals(res.getString("NOMBRE_REFERENCIACCVersion"))?"":"modificado"):"").append("' >&nbsp;").append(res.getString("NOMBRE_REFERENCIACCVersion")).append("</td>");
                            innerHTML.append("<td>&nbsp;").append(res.getString("UNIDAD")).append("</td>");
                            innerHTML.append("</tr>");
                        }
                       innerHTML.append("</table>");
                       innerHTML.append("<table clas/s='tablaComparacion'  cellpadding='0' cellspacing='0' id='tablaMP' style='margin-top:1em;'> ");
                        innerHTML.append(" <thead><tr  align='center'><td  colspan='8'><span class='outputText2'>Diferencias MP</span></td>");
                        innerHTML.append(" </tr><tr  align='center'><td rowspan='2' ><span class='outputText2' >Material</span></td>");
                        innerHTML.append("<td colspan='2' ><span class='outputText2'>Cantidad</span></td>");
                        innerHTML.append("<td rowspan='2' ><span class='outputText2'>Unidad Medida</span></td>");
                        innerHTML.append("<td colspan='2'><span class='outputText2'>Nro Fracciones</span></td>");
                        innerHTML.append("<td colspan='2' ><span class='outputText2'>Fracciones</span></td></tr><tr>");
                        innerHTML.append("<td><span class='outputText2'>Antes</span></td><td><span class='outputText2'>Despues</span></td>");
                        innerHTML.append("<td><span class='outputText2'>Antes</span></td><td><span class='outputText2'>Despues</span></td>");
                        innerHTML.append("<td><span class='outputText2'>Antes</span></td><td><span class='outputText2'>Despues</span></td> </tr></thead><tbody>");
                        consulta=new StringBuilder("select c.COD_FORMULA_MAESTRA,c.COD_VERSION from FORMULA_MAESTRA_VERSION c where c.COD_COMPPROD_VERSION='").append(codVersion).append("'");
                        res=st.executeQuery(consulta.toString());
                        int codFormulaMaestra=0;
                        int codVersionFM=0;
                        if(res.next())
                        {
                            codFormulaMaestra=res.getInt("COD_FORMULA_MAESTRA");
                            codVersionFM=res.getInt("COD_VERSION");
                        }

                        consulta=new StringBuilder("select m.NOMBRE_MATERIAL,m.COD_MATERIAL,fmd.CANTIDAD,fmdv.CANTIDAD as cantidad2,");
                         consulta.append(" fmd.NRO_PREPARACIONES,fmdv.NRO_PREPARACIONES as NRO_PREPARACIONES2,um.NOMBRE_UNIDAD_MEDIDA,fracciones.cantidadIni,fracciones.cantidadFin");
                         consulta.append(" from  FORMULA_MAESTRA_DETALLE_MP fmd full outer join FORMULA_MAESTRA_DETALLE_MP_VERSION fmdv");
                         consulta.append(" on fmd.COD_MATERIAL=fmdv.COD_MATERIAL and fmdv.COD_VERSION='").append(codVersionFM).append("'");
                         consulta.append(" and fmd.COD_FORMULA_MAESTRA=fmdv.COD_FORMULA_MAESTRA");
                         consulta.append(" inner join materiales m on (m.COD_MATERIAL=fmd.COD_MATERIAL or m.COD_MATERIAL=fmdv.COD_MATERIAL)");
                         consulta.append(" inner join UNIDADES_MEDIDA um on (um.COD_UNIDAD_MEDIDA=fmd.COD_UNIDAD_MEDIDA or um.COD_UNIDAD_MEDIDA=fmdv.COD_UNIDAD_MEDIDA)");
                         consulta.append(" outer apply(select fmdf.CANTIDAD as cantidadIni,fmdfv.CANTIDAD as cantidadFin");
                         consulta.append("  from FORMULA_MAESTRA_DETALLE_MP_FRACCIONES fmdf full outer join FORMULA_MAESTRA_DETALLE_MP_FRACCIONES_VERSION fmdfv on ");
                         consulta.append(" fmdf.COD_MATERIAL=fmdfv.COD_MATERIAL and fmdf.COD_FORMULA_MAESTRA=fmdfv.COD_FORMULA_MAESTRA  and fmdf.COD_FORMULA_MAESTRA_FRACCIONES=fmdfv.COD_FORMULA_MAESTRA_FRACCIONES");
                         consulta.append(" and fmdfv.COD_VERSION=fmdv.COD_VERSION");
                         consulta.append(" where ((fmdf.COD_FORMULA_MAESTRA=fmd.COD_FORMULA_MAESTRA and fmdf.COD_MATERIAL=fmd.COD_MATERIAL  and fmdfv.COD_FORMULA_MAESTRA_FRACCIONES is null)or");
                         consulta.append(" (fmdfv.COD_FORMULA_MAESTRA=fmdv.COD_FORMULA_MAESTRA and fmdfv.COD_MATERIAL=fmdv.COD_MATERIAL and fmdfv.COD_VERSION=fmdv.COD_VERSION and fmdf.COD_FORMULA_MAESTRA_FRACCIONES is null)OR");
                         consulta.append(" (fmdfv.COD_FORMULA_MAESTRA=fmdv.COD_FORMULA_MAESTRA and fmdfv.COD_MATERIAL=fmdv.COD_MATERIAL and fmdfv.COD_VERSION=fmdv.COD_VERSION and fmdf.COD_FORMULA_MAESTRA_FRACCIONES=fmdfv.COD_FORMULA_MAESTRA_FRACCIONES");
                         consulta.append(" and fmdf.COD_MATERIAL=fmdfv.COD_MATERIAL and fmdfv.COD_FORMULA_MAESTRA_FRACCIONES=fmdf.COD_FORMULA_MAESTRA_FRACCIONES))) fracciones");
                         consulta.append(" where ((fmd.COD_FORMULA_MAESTRA='").append(codFormulaMaestra).append("' and fmdv.COD_VERSION is null) OR");
                         consulta.append(" (fmd.COD_FORMULA_MAESTRA is null and fmdv.COD_FORMULA_MAESTRA='").append(codFormulaMaestra).append("'");
                         consulta.append(" and fmdv.COD_VERSION='").append(codVersionFM).append("')");
                         consulta.append(" OR( fmd.COD_FORMULA_MAESTRA=fmdv.COD_FORMULA_MAESTRA and fmdv.COD_VERSION='").append(codVersionFM).append("'");
                         consulta.append(" and fmd.COD_FORMULA_MAESTRA='").append(codFormulaMaestra).append("'))");
                         consulta.append(" order by m.NOMBRE_MATERIAL");
                                
                                res=st.executeQuery(consulta.toString());
                                int codMaterialCabecera=0;
                                StringBuilder fracciones=new StringBuilder("");
                                int contFracciones=0;
                                while(res.next())
                                {
                                    if(codMaterialCabecera!=res.getInt("COD_MATERIAL"))
                                    {
                                        if(codMaterialCabecera>0)
                                        {
                                            res.previous();
                                            innerHTML.append("<tr>");
                                            innerHTML.append("<td class='").append(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":"")).append("' rowspan='").append(contFracciones).append("' ><span class='outputText2'>").append(res.getString("NOMBRE_MATERIAL")).append("</span></td>");
                                            innerHTML.append("<td class='").append(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("cantidad2")!=res.getInt("CANTIDAD")?"modificado":""))).append("' rowspan='").append(contFracciones).append("' ><span class='outputText2'>").append(formato.format(res.getDouble("CANTIDAD"))).append("</span></td>");
                                            innerHTML.append("<td class='").append(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("cantidad2")!=res.getInt("CANTIDAD")?"modificado":""))).append("' rowspan='").append(contFracciones).append("' ><span class='outputText2'>").append(formato.format(res.getDouble("CANTIDAD2"))).append("</span></td>");
                                            innerHTML.append("<td class='").append(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":"")).append("' rowspan='").append(contFracciones).append("' ><span class='outputText2'>").append(res.getString("NOMBRE_UNIDAD_MEDIDA")).append("</span></td>");
                                            innerHTML.append("<td class='").append(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("NRO_PREPARACIONES")!=res.getInt("NRO_PREPARACIONES2")?"modificado":""))).append("' rowspan='").append(contFracciones).append("' ><span class='outputText2'>").append(res.getInt("NRO_PREPARACIONES")).append("</span></td>");
                                            innerHTML.append("<td class='").append(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("NRO_PREPARACIONES")!=res.getInt("NRO_PREPARACIONES2")?"modificado":""))).append("' rowspan='").append(contFracciones).append("' ><span class='outputText2'>").append(res.getInt("NRO_PREPARACIONES2")).append("</span></td>");
                                            innerHTML.append(fracciones.toString());
                                            res.next();

                                        }
                                        codMaterialCabecera=res.getInt("COD_MATERIAL");
                                        contFracciones=0;
                                        fracciones=new StringBuilder("");
                                    }
                                    contFracciones++;
                                    fracciones.append(contFracciones==1?"":"<tr>").append("<td class=").append(res.getString("cantidadIni")==null?"nuevo":(res.getString("cantidadFin")==null?"eliminado":(res.getDouble("cantidadIni")!=res.getDouble("cantidadFin")?"modificado":""))).append(" ><span class='outputText2'>").append(formato.format(res.getDouble("cantidadIni"))).append("</span></td>");
                                    fracciones.append("<td class=").append(res.getString("cantidadIni")==null?"nuevo":(res.getString("cantidadFin")==null?"eliminado":(res.getDouble("cantidadIni")!=res.getDouble("cantidadFin")?"modificado":""))).append(" ><span class='outputText2'>").append(formato.format(res.getDouble("cantidadFin"))).append("</span></td></tr>");
                                 }
                                 if(codMaterialCabecera>0)
                                 {
                                     res.last();
                                     innerHTML.append("<tr>");
                                     innerHTML.append("<td class='").append(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":"")).append("' rowspan='").append(contFracciones).append("' ><span class='outputText2'>").append(res.getString("NOMBRE_MATERIAL")).append("</span></td>");
                                     innerHTML.append("<td class='").append(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("cantidad2")!=res.getInt("CANTIDAD")?"modificado":""))).append("' rowspan='").append(contFracciones).append("' ><span class='outputText2'>").append(formato.format(res.getDouble("CANTIDAD"))).append("</span></td>");
                                     innerHTML.append("<td class='").append(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("cantidad2")!=res.getInt("CANTIDAD")?"modificado":""))).append("' rowspan='").append(contFracciones).append("' ><span class='outputText2'>").append(formato.format(res.getDouble("CANTIDAD2"))).append("</span></td>");
                                     innerHTML.append("<td class='").append(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":"")).append("' rowspan='").append(contFracciones).append("' ><span class='outputText2'>").append(res.getString("NOMBRE_UNIDAD_MEDIDA")).append("</span></td>");
                                     innerHTML.append("<td class='").append(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("NRO_PREPARACIONES")!=res.getInt("NRO_PREPARACIONES2")?"modificado":""))).append("' rowspan='").append(contFracciones).append("' ><span class='outputText2'>").append(res.getInt("NRO_PREPARACIONES")).append("</span></td>");
                                     innerHTML.append("<td class='").append(res.getString("cantidad")==null?"nuevo":(res.getString("cantidad2")==null?"eliminado":(res.getDouble("NRO_PREPARACIONES")!=res.getInt("NRO_PREPARACIONES2")?"modificado":""))).append("' rowspan='").append(contFracciones).append("' ><span class='outputText2'>").append(res.getInt("NRO_PREPARACIONES2")).append("</span></td>");
                                     innerHTML.append(fracciones.toString());
                                 }
                                 innerHTML.append("</tbody></table><table class='tablaComparacion'  cellpadding='0' cellspacing='0' style='margin-top:1em;' id='tablaEP'>");
                                 innerHTML.append(" <thead><tr  align='center'><td  colspan='8'><span class='outputText2'>Diferencias EP</span></td>");
                                 innerHTML.append(" </tr></thead><tbody>");
                                 consulta=new StringBuilder("select ep.nombre_envaseprim,ep.cod_envaseprim,p.CANTIDAD,");
                                  consulta.append(" p.cod_presentacion_primaria,tpp.COD_TIPO_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD,");
                                  consulta.append(" er.COD_ESTADO_REGISTRO,er.NOMBRE_ESTADO_REGISTRO");
                                  consulta.append(" from PRESENTACIONES_PRIMARIAS_VERSION p inner join ENVASES_PRIMARIOS ep on");
                                  consulta.append(" p.COD_ENVASEPRIM=ep.cod_envaseprim");
                                  consulta.append(" inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=p.COD_TIPO_PROGRAMA_PROD");
                                  consulta.append(" inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=p.COD_ESTADO_REGISTRO");
                                  consulta.append(" where p.COD_VERSION='").append(codVersion).append("'");
                                  consulta.append(" and p.COD_COMPPROD='").append(codCompProd).append("'");
                                  consulta.append(" order by tpp.NOMBRE_TIPO_PROGRAMA_PROD");
                                 
                                 res=st.executeQuery(consulta.toString());
                                 while(res.next())
                                 {
                                     innerHTML.append("<tr><td class='cabecera1' colspan='8' align='center'><span class='outputText2'>");
                                     innerHTML.append("Tipo Prog:").append(res.getString("NOMBRE_TIPO_PROGRAMA_PROD")).append("<br/>Envase:").append(res.getString("nombre_envaseprim")).append("<br/>");
                                     innerHTML.append("Estado:").append(res.getString("NOMBRE_ESTADO_REGISTRO")).append("<br/>Cantidad:").append(res.getInt("CANTIDAD")).append("</span></td></tr>");
                                     innerHTML.append("<tr  class='cabecera1' align='center'><td rowspan='2' ><span class='outputText2' >Material</span></td>");
                                    innerHTML.append("<td colspan='2' ><span class='outputText2'>Cantidad</span></td>");
                                    innerHTML.append("<td rowspan='2' ><span class='outputText2'>Unidad Medida</span></td><tr class='cabecera1'>");
                                    innerHTML.append("<td><span class='outputText2'>Antes</span></td><td><span class='outputText2'>Despues</span></td></tr>");
                                    consulta=new StringBuilder("select m.NOMBRE_MATERIAL,fmde.CANTIDAD,fmdev.CANTIDAD as cantidad2,um.NOMBRE_UNIDAD_MEDIDA");
                                     consulta.append(" from FORMULA_MAESTRA_DETALLE_EP fmde full outer join FORMULA_MAESTRA_DETALLE_EP_VERSION fmdev");
                                     consulta.append("  on fmde.COD_FORMULA_MAESTRA=fmdev.COD_FORMULA_MAESTRA and fmde.COD_MATERIAL=fmdev.COD_MATERIAL and fmdev.COD_VERSION=").append(codVersionFM);
                                     consulta.append(" and fmde.COD_PRESENTACION_PRIMARIA=fmdev.COD_PRESENTACION_PRIMARIA");
                                     consulta.append(" inner join materiales m on (m.COD_MATERIAL=fmde.COD_MATERIAL or m.COD_MATERIAL=fmdev.COD_MATERIAL)");
                                     consulta.append(" inner join UNIDADES_MEDIDA um on (um.COD_UNIDAD_MEDIDA=fmde.COD_UNIDAD_MEDIDA or um.COD_UNIDAD_MEDIDA=fmdev.COD_UNIDAD_MEDIDA)");
                                     consulta.append(" where ((fmde.COD_FORMULA_MAESTRA='").append(codFormulaMaestra).append("'");
                                     consulta.append(" and fmde.COD_PRESENTACION_PRIMARIA='").append(res.getString("cod_presentacion_primaria")).append("' and fmdev.COD_VERSION is null)");
                                     consulta.append(" or(fmde.COD_FORMULA_MAESTRA is null and fmdev.COD_FORMULA_MAESTRA='").append(codFormulaMaestra).append("'");
                                     consulta.append(" and fmdev.COD_VERSION='").append(codVersionFM).append("'");
                                     consulta.append(" and fmdev.COD_PRESENTACION_PRIMARIA='").append(res.getString("cod_presentacion_primaria")).append("')OR");
                                     consulta.append(" (fmde.COD_FORMULA_MAESTRA='").append(codFormulaMaestra).append("'");
                                     consulta.append(" and fmde.COD_PRESENTACION_PRIMARIA='").append(res.getString("cod_presentacion_primaria")).append("'");
                                     consulta.append(" and fmdev.COD_VERSION ='").append(codVersionFM).append("'))");
                                     
                                     resDetalle=stDetalle.executeQuery(consulta.toString());
                                     while(resDetalle.next())
                                     {
                                          innerHTML.append("<tr>");
                                          innerHTML.append("<td class='").append(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":"")).append("'><span class='outputText2'>").append(resDetalle.getString("NOMBRE_MATERIAL")).append("</span></td>");
                                          innerHTML.append("<td class='").append(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getDouble("cantidad")!=resDetalle.getDouble("cantidad2")?"modificado":""))).append("'><span class='outputText2'>").append(formato.format(resDetalle.getDouble("cantidad"))).append("</span></td>");
                                          innerHTML.append("<td class='").append(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getDouble("cantidad")!=resDetalle.getDouble("cantidad2")?"modificado":""))).append("'><span class='outputText2'>").append(formato.format(resDetalle.getDouble("cantidad2"))).append("</span></td>");
                                          innerHTML.append("<td class='").append(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":"")).append("'><span class='outputText2'>").append(resDetalle.getString("NOMBRE_UNIDAD_MEDIDA")).append("</span></td>");
                                          innerHTML.append("</tr>");
                                     }

                                 }
                            innerHTML.append("</tbody></table><table class='tablaComparacion'  cellpadding='0' cellspacing='0' style='margin-top:1em;' id='tablaES'>");
                            innerHTML.append(" <thead><tr  align='center'><td  colspan='8'><span class='outputText2'>Diferencias ES</span></td>");
                            innerHTML.append(" </tr></thead><tbody>");
                            consulta=new StringBuilder("select es.NOMBRE_ENVASESEC,es.COD_ENVASESEC,pp.NOMBRE_PRODUCTO_PRESENTACION,pp.cantidad_presentacion,");
                             consulta.append(" pp.cod_presentacion,TPP.NOMBRE_TIPO_PROGRAMA_PROD,tpp.COD_TIPO_PROGRAMA_PROD");
                             consulta.append(" from COMPONENTES_PRESPROD_VERSION cpp inner join PRESENTACIONES_PRODUCTO pp on");
                             consulta.append(" cpp.COD_PRESENTACION=pp.cod_presentacion");
                             consulta.append(" inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=cpp.COD_TIPO_PROGRAMA_PROD");
                             consulta.append(" inner join ENVASES_SECUNDARIOS es on es.COD_ENVASESEC=pp.COD_ENVASESEC");
                             consulta.append(" where cpp.COD_COMPPROD='").append(codCompProd).append("'");
                             consulta.append(" and cpp.COD_VERSION='").append(codVersion).append("'");
                             consulta.append(" order by tpp.COD_TIPO_PROGRAMA_PROD");
                             
                             res=st.executeQuery(consulta.toString());
                             while(res.next())
                             {
                                 innerHTML.append("<tr><td class='cabecera1' colspan='8' align='center'><span class='outputText2'>");
                                 innerHTML.append("Tipo Prog:").append(res.getString("NOMBRE_TIPO_PROGRAMA_PROD")).append("<br/>Presentacion:").append(res.getString("NOMBRE_ENVASESEC")).append("<br/>");
                                 innerHTML.append("Cantidad:").append(res.getInt("cantidad_presentacion")).append("</span></td></tr>");
                                 innerHTML.append("<tr  class='cabecera1' align='center'><td rowspan='2' ><span class='outputText2' >Material</span></td>");
                                innerHTML.append("<td colspan='2' ><span class='outputText2'>Cantidad</span></td>");
                                innerHTML.append("<td rowspan='2' ><span class='outputText2'>Unidad Medida</span></td><tr class='cabecera1'>");
                                innerHTML.append("<td><span class='outputText2'>Antes</span></td><td><span class='outputText2'>Despues</span></td></tr>");
                                 consulta=new StringBuilder("select m.NOMBRE_MATERIAL,fmd.CANTIDAD,fmdv.CANTIDAD as cantidad2,um.NOMBRE_UNIDAD_MEDIDA,er.NOMBRE_ESTADO_REGISTRO");
                                  consulta.append(" from FORMULA_MAESTRA_DETALLE_ES fmd full outer join FORMULA_MAESTRA_DETALLE_ES_VERSION fmdv");
                                  consulta.append(" on fmdv.COD_FORMULA_MAESTRA=fmd.COD_FORMULA_MAESTRA and fmd.COD_MATERIAL=fmdv.COD_MATERIAL");
                                  consulta.append(" and fmdv.COD_PRESENTACION_PRODUCTO=fmd.COD_PRESENTACION_PRODUCTO");
                                  consulta.append(" and fmdv.COD_TIPO_PROGRAMA_PROD=fmd.COD_TIPO_PROGRAMA_PROD and fmdv.COD_VERSION='").append(codVersionFM).append("'");
                                  consulta.append(" inner join materiales m on (m.COD_MATERIAL=fmd.COD_MATERIAL or m.COD_MATERIAL=fmdv.COD_MATERIAL)");
                                  consulta.append(" inner join UNIDADES_MEDIDA um on (um.COD_UNIDAD_MEDIDA=fmdv.COD_UNIDAD_MEDIDA or um.COD_UNIDAD_MEDIDA=fmd.COD_UNIDAD_MEDIDA)");
                                  consulta.append(" inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=m.COD_ESTADO_REGISTRO");
                                  consulta.append(" where ((fmd.COD_FORMULA_MAESTRA='").append(codFormulaMaestra).append("'");
                                  consulta.append(" and fmd.COD_PRESENTACION_PRODUCTO='").append(res.getInt("cod_presentacion")).append("' and fmd.COD_TIPO_PROGRAMA_PROD='").append(res.getInt("COD_TIPO_PROGRAMA_PROD")).append("'");
                                  consulta.append(" and fmdv.COD_VERSION is null) or");
                                  consulta.append(" (fmdv.COD_FORMULA_MAESTRA='").append(codFormulaMaestra).append("'");
                                  consulta.append(" and fmdv.COD_VERSION='").append(codVersionFM).append("'");
                                  consulta.append(" and fmdv.COD_TIPO_PROGRAMA_PROD='").append(res.getInt("COD_TIPO_PROGRAMA_PROD")).append("'");
                                  consulta.append(" and fmdv.COD_PRESENTACION_PRODUCTO='").append(res.getInt("cod_presentacion")).append("' )");
                                  consulta.append(" or (fmdv.COD_FORMULA_MAESTRA='").append(codFormulaMaestra).append("'");
                                  consulta.append(" and fmdv.COD_VERSION='").append(codVersionFM).append("'");
                                  consulta.append(" and fmdv.COD_TIPO_PROGRAMA_PROD='").append(res.getInt("COD_TIPO_PROGRAMA_PROD")).append("' and fmdv.COD_PRESENTACION_PRODUCTO='").append(res.getInt("cod_presentacion")).append("'");
                                  consulta.append(" and fmdv.COD_FORMULA_MAESTRA=fmd.COD_FORMULA_MAESTRA and fmd.COD_PRESENTACION_PRODUCTO=fmdv.COD_PRESENTACION_PRODUCTO");
                                  consulta.append(" and fmdv.COD_TIPO_PROGRAMA_PROD=fmd.COD_TIPO_PROGRAMA_PROD))order by m.NOMBRE_MATERIAL");
                                     
                                     resDetalle=stDetalle.executeQuery(consulta.toString());
                                     while(resDetalle.next())
                                     {
                                         innerHTML.append("<tr>");
                                         innerHTML.append("<td class='").append(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":"")).append("'><span class='outputText2'>").append(resDetalle.getString("NOMBRE_MATERIAL")).append("</span></td>");
                                         innerHTML.append("<td class='").append(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getDouble("cantidad")!=resDetalle.getDouble("cantidad2")?"modificado":""))).append("'><span class='outputText2'>").append(formato.format(resDetalle.getDouble("cantidad"))).append("</span></td>");
                                         innerHTML.append("<td class='").append(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getDouble("cantidad")!=resDetalle.getDouble("cantidad2")?"modificado":""))).append("'><span class='outputText2'>").append(formato.format(resDetalle.getDouble("cantidad2"))).append("</span></td>");
                                         innerHTML.append("<td class='").append(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":"")).append("'><span class='outputText2'>").append(resDetalle.getString("NOMBRE_UNIDAD_MEDIDA")).append("</span></td>");
                                         innerHTML.append("</tr>");
                                     }

                                 }
                                 innerHTML.append("</tbody></table><table class='tablaComparacion'  cellpadding='0' cellspacing='0' style='margin-top:1em;' id='tablaMR'>");
                                 innerHTML.append(" <thead><tr  align='center'><td  colspan='8'><span class='outputText2'>Diferencias MR</span></td>");
                                 innerHTML.append(" </tr></thead><tbody>");
                                 consulta=new StringBuilder("select tmr.COD_TIPO_MATERIAL_REACTIVO,tmr.NOMBRE_TIPO_MATERIAL_REACTIVO from TIPOS_MATERIAL_REACTIVO tmr where tmr.COD_ESTADO_REGISTRO=1 order by tmr.NOMBRE_TIPO_MATERIAL_REACTIVO");
                                 res=st.executeQuery(consulta.toString());
                                 while(res.next())
                                 {
                                     innerHTML.append("<tr><td class='cabecera1' colspan='8' align='center'><span class='outputText2'>");
                                     innerHTML.append("Tipo Material:").append(res.getString("NOMBRE_TIPO_MATERIAL_REACTIVO")).append("</span></td></tr>");
                                     innerHTML.append("<tr  class='cabecera1' align='center'><td rowspan='2' ><span class='outputText2' >Material</span></td>");
                                    innerHTML.append("<td colspan='2' ><span class='outputText2'>Cantidad</span></td>");
                                    innerHTML.append("<td rowspan='2' ><span class='outputText2'>Estado Material</span></td>");
                                    innerHTML.append("<td colspan='2' ><span class='outputText2'>Estado Analisis</span></td>");
                                    innerHTML.append("<td rowspan='2' ><span class='outputText2'>Analisis</span></td>");
                                    innerHTML.append("</tr><tr class='cabecera1'>");
                                    innerHTML.append("<td><span class='outputText2'>Antes</span></td><td><span class='outputText2'>Despues</span></td>");
                                    innerHTML.append("<td><span class='outputText2'>Antes</span></td><td><span class='outputText2'>Despues</span></td></tr>");
                                    consulta=new StringBuilder("select m.NOMBRE_MATERIAL,m.COD_MATERIAL,fmd.CANTIDAD,fmdv.CANTIDAD as cantidad2,er.NOMBRE_ESTADO_REGISTRO,");
                                   consulta.append(" tamr.nombre_tipo_analisis_material_reactivo,detalle.registrado,detalle.registrado2");
                                   consulta.append(" from FORMULA_MAESTRA_DETALLE_MR fmd full outer join FORMULA_MAESTRA_DETALLE_MR_VERSION fmdv on ");
                                   consulta.append(" fmd.COD_FORMULA_MAESTRA=fmdv.COD_FORMULA_MAESTRA and fmd.COD_MATERIAL=fmdv.COD_MATERIAL");
                                   consulta.append(" and fmd.COD_TIPO_MATERIAL=fmdv.COD_TIPO_MATERIAL");
                                   consulta.append(" and fmdv.COD_VERSION='").append(codVersionFM).append("'");
                                   consulta.append(" inner join MATERIALES m on (m.COD_MATERIAL=fmd.COD_MATERIAL or fmdv.COD_MATERIAL=m.COD_MATERIAL)");
                                   consulta.append(" inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=m.COD_ESTADO_REGISTRO");
                                   consulta.append(" outer APPLY TIPOS_ANALISIS_MATERIAL_REACTIVO tamr");
                                   consulta.append(" OUTER APPLY (select case when fmc.COD_MATERIAL>0 then 1 else 0 end as registrado, case when fmcv.COD_MATERIAL >0 then 1 else 0 end as registrado2");
                                   consulta.append(" from FORMULA_MAESTRA_MR_CLASIFICACION fmc full outer join FORMULA_MAESTRA_MR_CLASIFICACION_VERSION fmcv");
                                   consulta.append(" on fmc.COD_FORMULA_MAESTRA=fmcv.COD_FORMULA_MAESTRA and fmc.COD_MATERIAL=fmcv.COD_MATERIAL");
                                   consulta.append(" and fmc.COD_TIPO_ANALISIS_MATERIAL_REACTIVO=fmcv.COD_TIPO_ANALISIS_MATERIAL_REACTIVO");
                                   consulta.append(" and fmcv.COD_VERSION=fmdv.COD_VERSION");
                                   consulta.append(" where ((fmc.COD_FORMULA_MAESTRA=fmd.COD_FORMULA_MAESTRA and fmc.COD_MATERIAL=fmd.COD_MATERIAL ) or");
                                   consulta.append(" (fmcv.COD_FORMULA_MAESTRA=fmdv.COD_FORMULA_MAESTRA and  fmcv.COD_MATERIAL=fmdv.COD_MATERIAL and ");
                                   consulta.append(" fmcv.COD_VERSION=fmdv.COD_VERSION )) and (fmc.COD_TIPO_ANALISIS_MATERIAL_REACTIVO=tamr.COD_TIPO_ANALISIS_MATERIAL_REACTIVO");
                                   consulta.append(" or fmcv.COD_TIPO_ANALISIS_MATERIAL_REACTIVO=tamr.COD_TIPO_ANALISIS_MATERIAL_REACTIVO)) as detalle");
                                   consulta.append(" where ((fmd.COD_FORMULA_MAESTRA='").append(codFormulaMaestra).append("'");
                                   consulta.append(" and fmd.COD_TIPO_MATERIAL='").append(res.getInt("COD_TIPO_MATERIAL_REACTIVO")).append("')");
                                   consulta.append(" or(fmdv.COD_FORMULA_MAESTRA='").append(codFormulaMaestra).append("'");
                                   consulta.append(" and fmdv.COD_VERSION='").append(codVersionFM).append("'");
                                   consulta.append(" and fmdv.COD_TIPO_MATERIAL='").append(res.getInt("COD_TIPO_MATERIAL_REACTIVO")).append("' )) order by m.NOMBRE_MATERIAL,tamr.nombre_tipo_analisis_material_reactivo");
                                   
                                   resDetalle=stDetalle.executeQuery(consulta.toString());
                                   codMaterialCabecera=0;
                                   fracciones=new StringBuilder();
                                   while(resDetalle.next())
                                   {

                                       if((resDetalle.getRow()%2)==0)
                                       {
                                            innerHTML.append("<tr>");
                                            innerHTML.append("<td rowspan='2' class='").append(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":"")).append("'><span class='outputText2'>").append(resDetalle.getString("NOMBRE_MATERIAL")).append("</span></td>");
                                            innerHTML.append("<td rowspan='2' class='").append(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getDouble("cantidad")!=resDetalle.getDouble("cantidad2")?"modificado":""))).append("'><span class='outputText2'>").append(formato.format(resDetalle.getDouble("cantidad"))).append("</span></td>");
                                            innerHTML.append("<td rowspan='2' class='").append(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getDouble("cantidad")!=resDetalle.getDouble("cantidad2")?"modificado":""))).append("'><span class='outputText2'>").append(formato.format(resDetalle.getDouble("cantidad2"))).append("</span></td>");
                                            innerHTML.append("<td rowspan='2' class='").append(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":"")).append("'><span class='outputText2'>").append(resDetalle.getString("NOMBRE_ESTADO_REGISTRO")).append("</span></td>");
                                            innerHTML.append(fracciones.toString());
                                            innerHTML.append("</tr><tr>");
                                            innerHTML.append("<td class='").append(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getInt("registrado")!=resDetalle.getInt("registrado2")?"modificado":""))).append("'><input disabled='true' type='checkbox' ").append(resDetalle.getInt("registrado")>0?"checked":"").append("/></td>");
                                            innerHTML.append("<td class='").append(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getInt("registrado")!=resDetalle.getInt("registrado2")?"modificado":""))).append("'><input disabled='true' type='checkbox' ").append(resDetalle.getInt("registrado2")>0?"checked":"").append("/></td>");
                                            innerHTML.append("<td class='").append(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":"")).append("'><span class='outputText2'>").append(resDetalle.getString("nombre_tipo_analisis_material_reactivo")).append("</span></td></tr>");

                                       }
                                       else
                                       {
                                           fracciones=new StringBuilder("<td class='").append(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getInt("registrado")!=resDetalle.getInt("registrado2")?"modificado":""))).append("'><input disabled='true' type='checkbox' ").append(resDetalle.getInt("registrado")>0?"checked":"").append("/></td>");
                                           fracciones.append("<td class='").append(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":(resDetalle.getInt("registrado")!=resDetalle.getInt("registrado2")?"modificado":""))).append("'><input disabled='true' type='checkbox' ").append(resDetalle.getInt("registrado2")>0?"checked":"").append("/></td>");
                                           fracciones.append("<td class='").append(resDetalle.getString("cantidad")==null?"nuevo":(resDetalle.getString("cantidad2")==null?"eliminado":"")).append("'><span class='outputText2'>").append(resDetalle.getString("nombre_tipo_analisis_material_reactivo")).append("</span></td>");
                                       }
                                   }
                                 }
                                 innerHTML.append("</tbody></table>");
                                 con.close();
                    }
                    catch(SQLException ex)
                    {
                        ex.printStackTrace();
                    }
      return innerHTML.toString();
    }
    
    @Override
    public void run() 
    {
        try
        {
            direccion+=System.getProperty("file.separator");
            StringBuilder mensajeCorreo=new StringBuilder("<html> <head>  <title></title><meta http-equiv='Content-Type' content='text/html; charset=windows-1252'>");
                          mensajeCorreo.append("<style>span{font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 11px;}");
                          mensajeCorreo.append(".celdaDetalle{padding:3px !important; border-right: solid #bbbbbb 1px !important;border-bottom: solid #bbbbbb 1px !important;}");
                          mensajeCorreo.append(".cabecera{background-color:#9d5a9e;color:white;padding:2px;}" );
                          mensajeCorreo.append(".cabecera td{padding:3px !important; border-right: solid white 1px !important;border-bottom: solid white 1px !important;}" );
                          mensajeCorreo.append(".cabeceraVersion{background-color:#eeeeee;}" );
                          mensajeCorreo.append(".cabeceraVersionDetalle{padding:3px !important;}" );
                          mensajeCorreo.append(".tablaComparacion{font-family:Verdana, Arial, Helvetica, sans-serif;font-size:11px;margin-top:1em;top:1em;border-top:1px solid #aaaaaa;border-left:1px solid #aaaaaa;}");
                          mensajeCorreo.append(" .tablaComparacion tr td{padding:0.4em;border-bottom:1px solid #aaaaaa;border-right:1px solid #aaaaaa;}");
                          mensajeCorreo.append(" .tablaComparacion thead tr td{font-weight:bold;background-color:#ebeaeb;color:black;text-align:center;}");
                          mensajeCorreo.append(".eliminado{background-color:#FFB6C1;}");
                          mensajeCorreo.append(".modificado{background-color:#F0E68C;}");
                          mensajeCorreo.append(" .especificacion{font-weight:bold;background-color:white;}");
                          mensajeCorreo.append(" .nuevo{background-color:#b6f5b6;}");
                          mensajeCorreo.append(".celdaQuimica{background-color:white;font-weight:bold;}" );
                          mensajeCorreo.append("</style>");
                          if(enviarParaAprobacion)
                          {
                              mensajeCorreo.append("<span>Se envió a aprobación el versionamiento de un producto con los siguientes cambios:</span><br/><br/>" );
                          }
                          else
                          {
                                mensajeCorreo.append("<span>Se generó el versionamiento de un producto con los siguientes cambios:</span><br/><br/>" );
                          }
                          mensajeCorreo.append("<center><br/><br/>");
                          mensajeCorreo.append("<table class='cabeceraVersion' cellpadding='0' cellspacing='0' ><tr class='cabecera'><td colspan='4' align='center'><span>1. Información Diligenciada por Funcionario</span></td></tr>" );
                          mensajeCorreo.append("<tr><td class='cabeceraVersionDetalle' colspan='4'><span style='font-weight:bold'>Cambio Propuesto:</span></td></tr>");
                          mensajeCorreo.append("<tr><td  style='padding:1em;border:1px solid black;background-color:white' colspan='4'><center>").append(cambioPropuesto()).append("</center></td></tr>");
                          mensajeCorreo.append("</table>");
                          
                     Properties props = new Properties();
                     props.put("mail.smtp.host", "host2.cofar.com.bo");
                     props.put("mail.transport.protocol", "smtp");
                     props.put("mail.smtp.auth", "false");
                     props.setProperty("mail.user", "controlDeCambios@cofar.com.bo");
                     props.setProperty("mail.password", "105021ej");
                     Session mailSession = Session.getInstance(props, null);
                     Message msg = new MimeMessage(mailSession);
                     String asunto=(enviarParaAprobacion?"Notificación de envio a aprobación de version":"Notificación de creación de versión");
                     msg.setSubject(asunto);
                     
                     con = Util.openConnection(con);
                     Statement st = con.createStatement();
                     List<String[]> correosPersonal=new ArrayList<String[]>();
                     if(enviarParaAprobacion)
                     {
                         StringBuilder consulta=new StringBuilder("select c.COD_PERSONAL,c.nombre_correopersonal from correo_personal c");
                                       consulta.append(" where c.COD_PERSONAL in (select e.COD_PERSONAL from ENVIO_CORREOS_APROBACION_VERSION e where e.ENVIO_PARA_APROBACION=1)");
                                       ResultSet res=st.executeQuery(consulta.toString());
                                       while(res.next())
                                       {
                                            String[] areglo={res.getString("nombre_correopersonal"),res.getString("COD_PERSONAL")};
                                            correosPersonal.add(areglo);
                                       }
                            msg.setFrom(new InternetAddress("controlDeCambios@cofar.com.bo", "Envió a revisión de versión"));
                     }
                     else
                     {
                         StringBuilder consulta =new StringBuilder(" select cp.nombre_correopersonal,cp.COD_PERSONAL from correo_personal cp inner join PERMISOS_VERSION_CP pv on ");
                         consulta.append(" cp.COD_PERSONAL=pv.COD_PERSONAL where pv.PERSONAL_INVOLUCRADO_VERSION=1 and pv.COD_TIPO_MODIFICACION in (1,2,3,4)");
                         consulta.append(" and cp.COD_PERSONAL not in (select cpv.COD_PERSONAL from COMPONENTES_PROD_VERSION_MODIFICACION cpv where cpv.COD_VERSION='").append(codVersion).append("')");
                         ResultSet res = st.executeQuery(consulta.toString());
                         while(res.next())
                         {
                             String[] areglo={res.getString("nombre_correopersonal"),res.getString("COD_PERSONAL")};
                             correosPersonal.add(areglo);
                         }
                         msg.setFrom(new InternetAddress("controlDeCambios@cofar.com.bo", "Registro de Nueva Versión"));
                     }
                     st.close();
                     con.close();
                     InternetAddress emails[] = new InternetAddress[1];
                     for(String[] a:correosPersonal)
                     {
                         msg.setRecipient(Message.RecipientType.TO, new InternetAddress(a[0]));
                         StringBuilder correoPersona=new StringBuilder(mensajeCorreo.toString());
                         if(!enviarParaAprobacion)
                         {
                             correoPersona.append("<table class='cabeceraVersion' style='border:1px solid #9d5a9e;'cellpadding='0' cellspacing='0'><tr class='cabecera'><td colspan='2' align='center'><span style='font-size:15px;font-weight:bold'>Desea trabajar en la versión generada?</span></td></tr><tr>");
                             correoPersona.append("<td style='background-color:#23aa23;border:1px solid #145914;padding:0.6em' align='center'><a href=\"http://172.16.10.206:8088/PRODUCCION/componentesProdVersion/selecionarTransaccionCorreo.jsf?codEstadoVersion=1&codPersonal=").append(a[1]).append("&codVersion=").append(codVersion).append("\" title=\"agregarme a versión\" style='font-size:14px;font-weigth:bold'>SI</a></td>");
                             correoPersona.append("<td style='background-color:#f74413;border:1px solid #792913;padding:0.6em' align='center'><a href=\"http://172.16.10.206:8088/PRODUCCION/componentesProdVersion/selecionarTransaccionCorreo.jsf?codEstadoVersion=7&codPersonal=").append(a[1]).append("&codVersion=").append(codVersion).append("\" title=\"agregarme a versión\" style='font-size:14px;font-weigth:bold'>NO</a></td>");
                             correoPersona.append("</table>");
                         }
                         System.out.println("enviando correo a "+a[0]);
                         msg.setContent(correoPersona.toString(), "text/html");
                         javax.mail.Transport.send(msg);
                         
                     }
                     System.out.println("termino envio correos");
             
                     
            
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
            
    }
    
    
    
    
    

    
}
