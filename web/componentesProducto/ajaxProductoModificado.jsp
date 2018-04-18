<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>

<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@page import="java.text.*"%>

<head>
    <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
</head>

<%
out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
String codCompProd=request.getParameter("codCompProd");
String codVersion=request.getParameter("codVersion");
String estiloModif = "style='background-color:#F7FE2E'";
String estiloElim = "style='background-color:#FA8258'";
String estiloAgr = "style='background-color:#01DF3A'";
String estilo_ = "";
String sql= "	SELECT	"+
            "	  c.COD_PROD,p.nombre_prod nombre_prod_v,cp.COD_PROD COD_PROD_V,p1.nombre_prod nombre_prod,	"+
            "	  c.COD_FORMA,f.nombre_forma nombre_forma_v,cp.COD_FORMA COD_FORMA_V,f1.nombre_forma, "+
            "	  c.COD_ENVASEPRIM,e.nombre_envaseprim nombre_envaseprim_v,cp.COD_ENVASEPRIM COD_ENVASEPRIM_V,e1.nombre_envaseprim,	"+
            "	  c.COD_COLORPRESPRIMARIA,cl.NOMBRE_COLORPRESPRIMARIA NOMBRE_COLORPRESPRIMARIA_V,cp.COD_COLORPRESPRIMARIA COD_COLORPRESPRIMARIA_V,cl1.NOMBRE_COLORPRESPRIMARIA,	"+
            "	  c.VOLUMENPESO_ENVASEPRIM,a.NOMBRE_AREA_EMPRESA NOMBRE_AREA_EMPRESA_V,cp.VOLUMENPESO_ENVASEPRIM VOLUMENPESO_ENVASEPRIM_V,a1.NOMBRE_AREA_EMPRESA, "+
            "	  c.CANTIDAD_COMPPROD,cp.CANTIDAD_COMPPROD CANTIDAD_COMPPROD_V,	"+
            "	  c.COD_SABOR,s.NOMBRE_SABOR NOMBRE_SABOR_V,cp.COD_SABOR COD_SABOR_V,s1.NOMBRE_SABOR,	"+
            "	  c.volumenpeso_aproximado,cp.volumenpeso_aproximado volumenpeso_aproximado_v,	"+
            "	  c.COD_COMPUESTOPROD,cp.COD_COMPUESTOPROD COD_COMPUESTOPROD_V,	"+
            "	  c.nombre_prod_semiterminado nombre_prod_semiterminado_v,cp.nombre_prod_semiterminado nombre_prod_semiterminado_v,c.nombre_prod_semiterminado,	"+
            "	  c.NOMBRE_GENERICO,cp.NOMBRE_GENERICO NOMBRE_GENERICO_V,	"+
            "	  c.REG_SANITARIO,cp.REG_SANITARIO REG_SANITARIO_V,	"+
            "	  c.COD_LINEAMKT,l.NOMBRE_LINEAMKT,cp.COD_LINEAMKT COD_LINEAMKT_V,l1.NOMBRE_LINEAMKT,	"+
            "	  c.COD_CATEGORIACOMPPROD,cpr.NOMBRE_CATEGORIACOMPPROD,cp.COD_CATEGORIACOMPPROD COD_CATEGORIACOMPPROD_V,cpr1.NOMBRE_CATEGORIACOMPPROD,	"+
            "	  c.VIDA_UTIL,cp.VIDA_UTIL VIDA_UTIL_V,	"+
            "	  c.FECHA_VENCIMIENTO_RS,cp.FECHA_VENCIMIENTO_RS FECHA_VENCIMIENTO_RS_V,	"+
            "	  c.COD_ESTADO_COMPPROD,ec.NOMBRE_ESTADO_COMPPROD,cp.COD_ESTADO_COMPPROD COD_ESTADO_COMPPROD_V,ec1.NOMBRE_ESTADO_COMPPROD,	"+
            "	  c.RENDIMIENTO_PRODUCTO,cp.RENDIMIENTO_PRODUCTO RENDIMIENTO_PRODUCTO_V,	"+
            "	  c.COD_TIPO_PRODUCCION,t.NOMBRE_TIPO_PRODUCCION,cp.COD_TIPO_PRODUCCION COD_TIPO_PRODUCCION_V,t1.NOMBRE_TIPO_PRODUCCION,	"+
            "	  c.VOLUMEN_ENVASE_PRIMARIO,cp.VOLUMEN_ENVASE_PRIMARIO VOLUMEN_ENVASE_PRIMARIO_V,	"+
            "	  c.CONCENTRACION_ENVASE_PRIMARIO,cp.CONCENTRACION_ENVASE_PRIMARIO CONCENTRACION_ENVASE_PRIMARIO_V,	"+
            "	  c.PESO_ENVASE_PRIMARIO,cp.PESO_ENVASE_PRIMARIO PESO_ENVASE_PRIMARIO_V,	"+
            "	  c.DIRECCION_ARCHIVO_REGISTRO_SANITARIO,cp.DIRECCION_ARCHIVO_REGISTRO_SANITARIO DIRECCION_ARCHIVO_REGISTRO_SANITARIO_V,	"+
            "	  c.COD_VIA_ADMINISTRACION_PRODUCTO,v.NOMBRE_VIA_ADMINISTRACION_PRODUCTO,cp.COD_VIA_ADMINISTRACION_PRODUCTO COD_VIA_ADMINISTRACION_PRODUCTO_V,v1.NOMBRE_VIA_ADMINISTRACION_PRODUCTO	"+
            "	  c.CANTIDAD_VOLUMEN,cp.CANTIDAD_VOLUMEN CANTIDAD_VOLUMEN_V, "+
            "	  c.COD_UNIDAD_MEDIDA_VOLUMEN,  u.NOMBRE_UNIDAD_MEDIDA,u.abreviatura, cp.COD_UNIDAD_MEDIDA_VOLUMEN COD_UNIDAD_MEDIDA_VOLUMEN_V,u1.NOMBRE_UNIDAD_MEDIDA,u1.abreviatura,	"+
            "	  c.TOLERANCIA_VOLUMEN_FABRICAR,cp.TOLERANCIA_VOLUMEN_FABRICAR TOLERANCIA_VOLUMEN_FABRICAR_V, "+
            "	  c.COD_TIPO_COMPPROD_FORMATO, "+
            "	   " + //c.COD_TIPO_CLASIFICACION_PRODUCTO,
            "	  c.COD_AREA_EMPRESA,a.NOMBRE_AREA_EMPRESA,cp.COD_AREA_EMPRESA "+
            "	  FROM "+
            "	  COMPONENTES_PROD c "+
            "	  left outer join COMPONENTES_PROD_VERSION cp on cp.COD_COMPPROD = c.COD_COMPPROD	"+
            "	  left outer join PRODUCTOS p on p.cod_prod = cp.COD_PROD"+
            "	  left outer join FORMAS_FARMACEUTICAS f on f.cod_forma = cp.COD_FORMA	"+
            "	  left outer join ENVASES_PRIMARIOS e on e.cod_envaseprim = cp.COD_ENVASEPRIM	"+
            "	  left outer join COLORES_PRESPRIMARIA cl on cl.COD_COLORPRESPRIMARIA = cp.COD_COLORPRESPRIMARIA	"+
            "	  left outer join AREAS_EMPRESA a on a.COD_AREA_EMPRESA = cp.COD_AREA_EMPRESA	"+
            "	  left outer join SABORES_PRODUCTO s on s.COD_SABOR = cp.COD_SABOR	"+
            "	  left outer join LINEAS_MKT l on l.COD_LINEAMKT = cp.COD_LINEAMKT	"+
            "	  left outer join CATEGORIAS_COMPPROD cpr on cpr.COD_CATEGORIACOMPPROD = cp.COD_CATEGORIACOMPPROD	"+
            "	  left outer join UNIDADES_MEDIDA u on u.COD_UNIDAD_MEDIDA = cp.COD_UNIDAD_MEDIDA_VOLUMEN	"+
            "	  left outer join ESTADOS_COMPPROD ec on ec.COD_ESTADO_COMPPROD = cp.COD_ESTADO_COMPPROD	"+
            "	  left outer join VIAS_ADMINISTRACION_PRODUCTO v on v.COD_VIA_ADMINISTRACION_PRODUCTO = cp.COD_VIA_ADMINISTRACION_PRODUCTO	"+
            "	  left outer join TIPOS_PRODUCCION t on t.COD_TIPO_PRODUCCION = cp.COD_TIPO_PRODUCCION	"+
            "	  " +
            "	  left outer join PRODUCTOS p1 on p1.cod_prod = c.COD_PROD"+
            "	  left outer join FORMAS_FARMACEUTICAS f1 on f1.cod_forma = c.COD_FORMA	"+
            "	  left outer join ENVASES_PRIMARIOS e1 on e1.cod_envaseprim = c.COD_ENVASEPRIM	"+
            "	  left outer join COLORES_PRESPRIMARIA cl1 on cl1.COD_COLORPRESPRIMARIA = c.COD_COLORPRESPRIMARIA	"+
            "	  left outer join AREAS_EMPRESA a1 on a1.COD_AREA_EMPRESA = c.COD_AREA_EMPRESA	"+
            "	  left outer join SABORES_PRODUCTO s1 on s1.COD_SABOR = c.COD_SABOR	"+
            "	  left outer join LINEAS_MKT l11 on l.COD_LINEAMKT = c.COD_LINEAMKT	"+
            "	  left outer join CATEGORIAS_COMPPROD cpr1 on cpr1.COD_CATEGORIACOMPPROD = c.COD_CATEGORIACOMPPROD	"+
            "	  left outer join UNIDADES_MEDIDA u1 on u1.COD_UNIDAD_MEDIDA = c.COD_UNIDAD_MEDIDA_VOLUMEN	"+
            "	  left outer join ESTADOS_COMPPROD ec1 on ec1.COD_ESTADO_COMPPROD = c.COD_ESTADO_COMPPROD	"+
            "	  left outer join VIAS_ADMINISTRACION_PRODUCTO v1 on v1.COD_VIA_ADMINISTRACION_PRODUCTO = c.COD_VIA_ADMINISTRACION_PRODUCTO	"+
            "	  left outer join TIPOS_PRODUCCION t1 on t1.COD_TIPO_PRODUCCION = c.COD_TIPO_PRODUCCION	"+
            "	  where cp.COD_COMPPROD = '"+codCompProd+"' and cp.COD_VERSION = '"+codVersion+"'" +
            " union all " +
            " SELECT "+
            "	  '' COD_PROD,p.nombre_prod,cp.COD_PROD COD_PROD_V,	"+
            "	  '' COD_FORMA,f.nombre_forma,cp.COD_FORMA COD_FORMA_V,	"+
            "	  '' COD_ENVASEPRIM,e.nombre_envaseprim,cp.COD_ENVASEPRIM COD_ENVASEPRIM_V,	"+
            "	  '' COD_COLORPRESPRIMARIA,cl.NOMBRE_COLORPRESPRIMARIA,cp.COD_COLORPRESPRIMARIA COD_COLORPRESPRIMARIA_V,	"+
            "	  '' VOLUMENPESO_ENVASEPRIM,a.NOMBRE_AREA_EMPRESA,cp.VOLUMENPESO_ENVASEPRIM VOLUMENPESO_ENVASEPRIM_V,	"+
            "	  '' CANTIDAD_COMPPROD,cp.CANTIDAD_COMPPROD CANTIDAD_COMPPROD_V,	"+
            "	  '' COD_SABOR,s.NOMBRE_SABOR,cp.COD_SABOR COD_SABOR_V,	"+
            "	  '' volumenpeso_aproximado,cp.volumenpeso_aproximado volumenpeso_aproximado_v,	"+
            "	  '' COD_COMPUESTOPROD,cp.COD_COMPUESTOPROD COD_COMPUESTOPROD_V,	"+
            "	  '' nombre_prod_semiterminado,cp.nombre_prod_semiterminado nombre_prod_semiterminado_v,	"+
            "	  '' NOMBRE_GENERICO,cp.NOMBRE_GENERICO NOMBRE_GENERICO_V,	"+
            "	  '' REG_SANITARIO,cp.REG_SANITARIO REG_SANITARIO_V,	"+
            "	  '' COD_LINEAMKT,l.NOMBRE_LINEAMKT,cp.COD_LINEAMKT COD_LINEAMKT_V,	"+
            "	  '' COD_CATEGORIACOMPPROD,cpr.NOMBRE_CATEGORIACOMPPROD,cp.COD_CATEGORIACOMPPROD COD_CATEGORIACOMPPROD_V,	"+
            "	  '' VIDA_UTIL,cp.VIDA_UTIL VIDA_UTIL_V,	"+
            "	  '' FECHA_VENCIMIENTO_RS,cp.FECHA_VENCIMIENTO_RS FECHA_VENCIMIENTO_RS_V,	"+
            "	  '' COD_ESTADO_COMPPROD,ec.NOMBRE_ESTADO_COMPPROD,cp.COD_ESTADO_COMPPROD COD_ESTADO_COMPPROD_V,	"+
            "	  '' RENDIMIENTO_PRODUCTO,cp.RENDIMIENTO_PRODUCTO RENDIMIENTO_PRODUCTO_V,	"+
            "	  '' COD_TIPO_PRODUCCION,t.NOMBRE_TIPO_PRODUCCION,cp.COD_TIPO_PRODUCCION COD_TIPO_PRODUCCION_V,	"+
            "	  '' VOLUMEN_ENVASE_PRIMARIO,cp.VOLUMEN_ENVASE_PRIMARIO VOLUMEN_ENVASE_PRIMARIO_V,	"+
            "	  '' CONCENTRACION_ENVASE_PRIMARIO,cp.CONCENTRACION_ENVASE_PRIMARIO CONCENTRACION_ENVASE_PRIMARIO_V,	"+
            "	  '' PESO_ENVASE_PRIMARIO,cp.PESO_ENVASE_PRIMARIO PESO_ENVASE_PRIMARIO_V,	"+
            "	  '' DIRECCION_ARCHIVO_REGISTRO_SANITARIO,cp.DIRECCION_ARCHIVO_REGISTRO_SANITARIO DIRECCION_ARCHIVO_REGISTRO_SANITARIO_V,	"+
            "	  '' COD_VIA_ADMINISTRACION_PRODUCTO,v.NOMBRE_VIA_ADMINISTRACION_PRODUCTO,cp.COD_VIA_ADMINISTRACION_PRODUCTO COD_VIA_ADMINISTRACION_PRODUCTO_V,	"+
            "	  '' CANTIDAD_VOLUMEN,cp.CANTIDAD_VOLUMEN CANTIDAD_VOLUMEN_V, "+
            "	  '' COD_UNIDAD_MEDIDA_VOLUMEN, u.NOMBRE_UNIDAD_MEDIDA,u.abreviatura, cp.COD_UNIDAD_MEDIDA_VOLUMEN COD_UNIDAD_MEDIDA_VOLUMEN_V,	"+
            "	  '' TOLERANCIA_VOLUMEN_FABRICAR,cp.TOLERANCIA_VOLUMEN_FABRICAR TOLERANCIA_VOLUMEN_FABRICAR_V, "+
            "	  '' COD_TIPO_COMPPROD_FORMATO "+
            "	   " + //c.COD_TIPO_CLASIFICACION_PRODUCTO,
            "	  ,cp.COD_AREA_EMPRESA,a.NOMBRE_AREA_EMPRESA,cp.COD_AREA_EMPRESA  "+
            "	  from COMPONENTES_PROD_VERSION cp "+
            "	  left outer join PRODUCTOS p on p.cod_prod = cp.COD_PROD	"+
            "	  left outer join FORMAS_FARMACEUTICAS f on f.cod_forma = cp.COD_FORMA	"+
            "	  left outer join ENVASES_PRIMARIOS e on e.cod_envaseprim = cp.COD_ENVASEPRIM	"+
            "	  left outer join COLORES_PRESPRIMARIA cl on cl.COD_COLORPRESPRIMARIA = cp.COD_COLORPRESPRIMARIA	"+
            "	  left outer join AREAS_EMPRESA a on a.COD_AREA_EMPRESA = cp.COD_AREA_EMPRESA	"+
            "	  left outer join SABORES_PRODUCTO s on s.COD_SABOR = cp.COD_SABOR	"+
            "	  left outer join LINEAS_MKT l on l.COD_LINEAMKT = cp.COD_LINEAMKT	"+
            "	  left outer join CATEGORIAS_COMPPROD cpr on cpr.COD_CATEGORIACOMPPROD = cp.COD_CATEGORIACOMPPROD	"+
            "	  left outer join UNIDADES_MEDIDA u on u.COD_UNIDAD_MEDIDA = cp.COD_UNIDAD_MEDIDA_VOLUMEN	"+
            "	  left outer join ESTADOS_COMPPROD ec on ec.COD_ESTADO_COMPPROD = cp.COD_ESTADO_COMPPROD	"+
            "	  left outer join VIAS_ADMINISTRACION_PRODUCTO v on v.COD_VIA_ADMINISTRACION_PRODUCTO = cp.COD_VIA_ADMINISTRACION_PRODUCTO	"+
            "	  left outer join TIPOS_PRODUCCION t on t.COD_TIPO_PRODUCCION = cp.COD_TIPO_PRODUCCION	"+
            "	  where cp.COD_COMPPROD = '"+codCompProd+"' and cp.COD_VERSION = '"+codVersion+"' ";
       sql = " SELECT	"+
            "	  c.COD_PROD,p.nombre_prod ,cp.COD_PROD COD_PROD_V,p1.nombre_prod nombre_prod_v,	"+
            "	  c.COD_FORMA,f.nombre_forma ,cp.COD_FORMA COD_FORMA_V,f1.nombre_forma nombre_forma_v, "+
            "	  c.COD_ENVASEPRIM,e.nombre_envaseprim,cp.COD_ENVASEPRIM COD_ENVASEPRIM_V,e1.nombre_envaseprim nombre_envaseprim_v,	"+
            "	  c.COD_COLORPRESPRIMARIA,cl.NOMBRE_COLORPRESPRIMARIA,cp.COD_COLORPRESPRIMARIA COD_COLORPRESPRIMARIA_V,cl1.NOMBRE_COLORPRESPRIMARIA NOMBRE_COLORPRESPRIMARIA_V,	"+
            "	  c.VOLUMENPESO_ENVASEPRIM,cp.VOLUMENPESO_ENVASEPRIM VOLUMENPESO_ENVASEPRIM_V, "+
            "	  c.CANTIDAD_COMPPROD,cp.CANTIDAD_COMPPROD CANTIDAD_COMPPROD_V,	"+
            "	  c.COD_SABOR,s.NOMBRE_SABOR NOMBRE_SABOR,cp.COD_SABOR COD_SABOR_V,s1.NOMBRE_SABOR NOMBRE_SABOR_V,	"+
            "	  c.volumenpeso_aproximado,cp.volumenpeso_aproximado volumenpeso_aproximado_v,	"+
            "	  c.COD_COMPUESTOPROD,cp.COD_COMPUESTOPROD COD_COMPUESTOPROD_V,	"+
            "	  c.nombre_prod_semiterminado,cp.nombre_prod_semiterminado nombre_prod_semiterminado_v, "+
            "	  c.NOMBRE_GENERICO,cp.NOMBRE_GENERICO NOMBRE_GENERICO_V,	"+
            "	  c.REG_SANITARIO,cp.REG_SANITARIO REG_SANITARIO_V,	"+
            "	  c.COD_LINEAMKT,l.NOMBRE_LINEAMKT,cp.COD_LINEAMKT COD_LINEAMKT_V,l1.NOMBRE_LINEAMKT NOMBRE_LINEAMKT_V,	"+
            "	  c.COD_CATEGORIACOMPPROD,cpr.NOMBRE_CATEGORIACOMPPROD,cp.COD_CATEGORIACOMPPROD COD_CATEGORIACOMPPROD_V,cpr1.NOMBRE_CATEGORIACOMPPROD NOMBRE_CATEGORIACOMPPROD_V,	"+
            "	  c.VIDA_UTIL,cp.VIDA_UTIL VIDA_UTIL_V,	"+
            "	  c.FECHA_VENCIMIENTO_RS,cp.FECHA_VENCIMIENTO_RS FECHA_VENCIMIENTO_RS_V,	"+
            "	  c.COD_ESTADO_COMPPROD,ec.NOMBRE_ESTADO_COMPPROD,cp.COD_ESTADO_COMPPROD COD_ESTADO_COMPPROD_V,ec1.NOMBRE_ESTADO_COMPPROD NOMBRE_ESTADO_COMPPROD_V,	"+
            "	  c.RENDIMIENTO_PRODUCTO,cp.RENDIMIENTO_PRODUCTO RENDIMIENTO_PRODUCTO_V,	"+
            "	  c.COD_TIPO_PRODUCCION,t.NOMBRE_TIPO_PRODUCCION,cp.COD_TIPO_PRODUCCION COD_TIPO_PRODUCCION_V,t1.NOMBRE_TIPO_PRODUCCION NOMBRE_TIPO_PRODUCCION_V,	"+
            "	  c.VOLUMEN_ENVASE_PRIMARIO,cp.VOLUMEN_ENVASE_PRIMARIO VOLUMEN_ENVASE_PRIMARIO_V,	"+
            "	  c.CONCENTRACION_ENVASE_PRIMARIO,cp.CONCENTRACION_ENVASE_PRIMARIO CONCENTRACION_ENVASE_PRIMARIO_V,	"+
            "	  c.PESO_ENVASE_PRIMARIO,cp.PESO_ENVASE_PRIMARIO PESO_ENVASE_PRIMARIO_V,	"+
            "	  c.DIRECCION_ARCHIVO_REGISTRO_SANITARIO,cp.DIRECCION_ARCHIVO_REGISTRO_SANITARIO DIRECCION_ARCHIVO_REGISTRO_SANITARIO_V,	"+
            "	  c.COD_VIA_ADMINISTRACION_PRODUCTO,v.NOMBRE_VIA_ADMINISTRACION_PRODUCTO,cp.COD_VIA_ADMINISTRACION_PRODUCTO COD_VIA_ADMINISTRACION_PRODUCTO_V,v1.NOMBRE_VIA_ADMINISTRACION_PRODUCTO NOMBRE_VIA_ADMINISTRACION_PRODUCTO_V,	"+
            "	  c.CANTIDAD_VOLUMEN,cp.CANTIDAD_VOLUMEN CANTIDAD_VOLUMEN_V, "+
            "	  c.COD_UNIDAD_MEDIDA_VOLUMEN,u.abreviatura, cp.COD_UNIDAD_MEDIDA_VOLUMEN COD_UNIDAD_MEDIDA_VOLUMEN_V,u1.abreviatura abreviatura_v,	"+
            "	  c.TOLERANCIA_VOLUMEN_FABRICAR,cp.TOLERANCIA_VOLUMEN_FABRICAR TOLERANCIA_VOLUMEN_FABRICAR_V, "+
            "	  c.COD_TIPO_COMPPROD_FORMATO, "+
            "	   " + //c.COD_TIPO_CLASIFICACION_PRODUCTO,
            "	  c.COD_AREA_EMPRESA,a.NOMBRE_AREA_EMPRESA,cp.COD_AREA_EMPRESA,a1.NOMBRE_AREA_EMPRESA NOMBRE_AREA_EMPRESA_V "+
            "	  FROM "+
            "	  COMPONENTES_PROD c "+
            "	  FULL outer join COMPONENTES_PROD_VERSION cp on cp.COD_COMPPROD = c.COD_COMPPROD	"+
            "	  left outer join PRODUCTOS p on p.cod_prod = c.COD_PROD"+
            "	  left outer join FORMAS_FARMACEUTICAS f on f.cod_forma = c.COD_FORMA	"+
            "	  left outer join ENVASES_PRIMARIOS e on e.cod_envaseprim = c.COD_ENVASEPRIM	"+
            "	  left outer join COLORES_PRESPRIMARIA cl on cl.COD_COLORPRESPRIMARIA = c.COD_COLORPRESPRIMARIA	"+
            "	  left outer join AREAS_EMPRESA a on a.COD_AREA_EMPRESA = c.COD_AREA_EMPRESA	"+
            "	  left outer join SABORES_PRODUCTO s on s.COD_SABOR = c.COD_SABOR	"+
            "	  left outer join LINEAS_MKT l on l.COD_LINEAMKT = c.COD_LINEAMKT	"+
            "	  left outer join CATEGORIAS_COMPPROD cpr on cpr.COD_CATEGORIACOMPPROD = c.COD_CATEGORIACOMPPROD	"+
            "	  left outer join UNIDADES_MEDIDA u on u.COD_UNIDAD_MEDIDA = c.COD_UNIDAD_MEDIDA_VOLUMEN	"+
            "	  left outer join ESTADOS_COMPPROD ec on ec.COD_ESTADO_COMPPROD = c.COD_ESTADO_COMPPROD	"+
            "	  left outer join VIAS_ADMINISTRACION_PRODUCTO v on v.COD_VIA_ADMINISTRACION_PRODUCTO = c.COD_VIA_ADMINISTRACION_PRODUCTO	"+
            "	  left outer join TIPOS_PRODUCCION t on t.COD_TIPO_PRODUCCION = c.COD_TIPO_PRODUCCION	" +
            "	   left outer join PRODUCTOS p1 on p1.cod_prod = cp.COD_PROD"+
            "	  left outer join FORMAS_FARMACEUTICAS f1 on f1.cod_forma = cp.COD_FORMA	"+
            "	  left outer join ENVASES_PRIMARIOS e1 on e1.cod_envaseprim = cp.COD_ENVASEPRIM	"+
            "	  left outer join COLORES_PRESPRIMARIA cl1 on cl1.COD_COLORPRESPRIMARIA = cp.COD_COLORPRESPRIMARIA	"+
            "	  left outer join AREAS_EMPRESA a1 on a1.COD_AREA_EMPRESA = cp.COD_AREA_EMPRESA	"+
            "	  left outer join SABORES_PRODUCTO s1 on s1.COD_SABOR = cp.COD_SABOR	"+
            "	  left outer join LINEAS_MKT l1 on l1.COD_LINEAMKT = cp.COD_LINEAMKT	"+
            "	  left outer join CATEGORIAS_COMPPROD cpr1 on cpr1.COD_CATEGORIACOMPPROD = cp.COD_CATEGORIACOMPPROD	"+
            "	  left outer join UNIDADES_MEDIDA u1 on u1.COD_UNIDAD_MEDIDA = cp.COD_UNIDAD_MEDIDA_VOLUMEN	"+
            "	  left outer join ESTADOS_COMPPROD ec1 on ec1.COD_ESTADO_COMPPROD = cp.COD_ESTADO_COMPPROD	"+
            "	  left outer join VIAS_ADMINISTRACION_PRODUCTO v1 on v1.COD_VIA_ADMINISTRACION_PRODUCTO = cp.COD_VIA_ADMINISTRACION_PRODUCTO	"+
            "	  left outer join TIPOS_PRODUCCION t1 on t1.COD_TIPO_PRODUCCION = cp.COD_TIPO_PRODUCCION	" +
            //"     left outer join COMPONENTES_PROD_VERSION cp1 on cp1.COD_COMPPROD = cp.COD_COMPPROD" +
            "     where cp.COD_COMPPROD = '"+codCompProd+"' and cp.COD_VERSION = '"+codVersion+"' ";
       
        System.out.println("consulta"+sql);
Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(sql);
if(rs.next()){
    if(Integer.valueOf(codCompProd)<0){estiloModif = estiloAgr;estilo_ = estiloAgr;}
    String nombreProd = rs.getString("nombre_prod")==null?"":rs.getString("nombre_prod");
    String nombreProdv = rs.getString("nombre_prod_v")==null?"":rs.getString("nombre_prod_v");
    String nombreForma = rs.getString("nombre_prod")==null?"":rs.getString("nombre_forma");
    String nombreFormav = rs.getString("nombre_prod_v")==null?"":rs.getString("nombre_forma_v");
    String nombreEnvasePrim = rs.getString("nombre_envaseprim")==null?"":rs.getString("nombre_envaseprim");
    String nombreEnvasePrimv = rs.getString("nombre_envaseprim_v")==null?"":rs.getString("nombre_envaseprim_v");
    String colorPresPrimaria = rs.getString("NOMBRE_COLORPRESPRIMARIA")==null?"":rs.getString("NOMBRE_COLORPRESPRIMARIA");
    String colorPresPrimariav = rs.getString("NOMBRE_COLORPRESPRIMARIA_V")==null?"":rs.getString("NOMBRE_COLORPRESPRIMARIA_V");
    String cantCompProd = rs.getString("CANTIDAD_COMPPROD")==null?"":rs.getString("CANTIDAD_COMPPROD");
    String cantCompProdv = rs.getString("CANTIDAD_COMPPROD_V")==null?"":rs.getString("CANTIDAD_COMPPROD_V");
    String nombreSabor = rs.getString("NOMBRE_SABOR")==null?"":rs.getString("NOMBRE_SABOR");
    String nombreSaborv = rs.getString("NOMBRE_SABOR_V")==null?"":rs.getString("NOMBRE_SABOR_V");
    String nombreProdSemiterminado = rs.getString("nombre_prod_semiterminado")==null?"":rs.getString("nombre_prod_semiterminado");
    String nombreProdSemiterminadov = rs.getString("nombre_prod_semiterminado_v")==null?"":rs.getString("nombre_prod_semiterminado_v");
    String nombreGenerico = rs.getString("NOMBRE_GENERICO")==null?"":rs.getString("NOMBRE_GENERICO");
    String nombreGenericov = rs.getString("NOMBRE_GENERICO_V")==null?"":rs.getString("NOMBRE_GENERICO_V");
    String registroSanitario = rs.getString("REG_SANITARIO")==null?"":rs.getString("REG_SANITARIO");
    String registroSanitariov = rs.getString("REG_SANITARIO_V")==null?"":rs.getString("REG_SANITARIO_V");
    String nombreLineaMkt = rs.getString("NOMBRE_LINEAMKT")==null?"":rs.getString("NOMBRE_LINEAMKT");
    String nombreLineaMktv = rs.getString("NOMBRE_LINEAMKT_V")==null?"":rs.getString("NOMBRE_LINEAMKT_V");
    String nombreCategoriaCompProd = rs.getString("NOMBRE_CATEGORIACOMPPROD")==null?"":rs.getString("NOMBRE_CATEGORIACOMPPROD");
    String nombreCategoriaCompProdv = rs.getString("NOMBRE_CATEGORIACOMPPROD_V")==null?"":rs.getString("NOMBRE_CATEGORIACOMPPROD_V");
    String vidaUtil = rs.getString("VIDA_UTIL")==null?"":rs.getString("VIDA_UTIL");
    String vidaUtilv = rs.getString("VIDA_UTIL_V")==null?"":rs.getString("VIDA_UTIL_V");
    String nombreEstadoCompProd = rs.getString("NOMBRE_ESTADO_COMPPROD")==null?"":rs.getString("NOMBRE_ESTADO_COMPPROD");
    String nombreEstadoCompProdv = rs.getString("NOMBRE_ESTADO_COMPPROD_V")==null?"":rs.getString("NOMBRE_ESTADO_COMPPROD_V");
    String nombreTipoProduccion = rs.getString("NOMBRE_TIPO_PRODUCCION")==null?"":rs.getString("NOMBRE_TIPO_PRODUCCION");
    String nombreTipoProduccionv = rs.getString("NOMBRE_TIPO_PRODUCCION_V")==null?"":rs.getString("NOMBRE_TIPO_PRODUCCION_V");
    String volumenEnvasePrimario = rs.getString("VOLUMEN_ENVASE_PRIMARIO")==null?"":rs.getString("VOLUMEN_ENVASE_PRIMARIO");
    String volumenEnvasePrimariov = rs.getString("VOLUMEN_ENVASE_PRIMARIO_V")==null?"":rs.getString("VOLUMEN_ENVASE_PRIMARIO_V");
    String concentracionEnvasePrimario = rs.getString("CONCENTRACION_ENVASE_PRIMARIO")==null?"":rs.getString("CONCENTRACION_ENVASE_PRIMARIO");
    String concentracionEnvasePrimariov = rs.getString("CONCENTRACION_ENVASE_PRIMARIO_V")==null?"":rs.getString("CONCENTRACION_ENVASE_PRIMARIO_V");
    String pesoEnvasePrimario = rs.getString("PESO_ENVASE_PRIMARIO")==null?"":rs.getString("PESO_ENVASE_PRIMARIO");
    String pesoEnvasePrimariov = rs.getString("PESO_ENVASE_PRIMARIO_V")==null?"":rs.getString("PESO_ENVASE_PRIMARIO_V");
    String nombreViaAdministracionProducto = rs.getString("NOMBRE_VIA_ADMINISTRACION_PRODUCTO")==null?"":rs.getString("NOMBRE_VIA_ADMINISTRACION_PRODUCTO");
    String nombreViaAdministracionProductov = rs.getString("NOMBRE_VIA_ADMINISTRACION_PRODUCTO_V")==null?"":rs.getString("NOMBRE_VIA_ADMINISTRACION_PRODUCTO_V");
    double toleranciaVolumenFabricar = rs.getDouble("TOLERANCIA_VOLUMEN_FABRICAR");
    double toleranciaVolumenFabricarv = rs.getDouble("TOLERANCIA_VOLUMEN_FABRICAR_V");
    String nombreAreaEmpresa = rs.getString("NOMBRE_AREA_EMPRESA")==null?"":rs.getString("NOMBRE_AREA_EMPRESA");
    String nombreAreaEmpresav = rs.getString("NOMBRE_AREA_EMPRESA_V")==null?"":rs.getString("NOMBRE_AREA_EMPRESA_V");
    String abreviatura = rs.getString("abreviatura")==null?"":rs.getString("abreviatura");
    String abreviaturav = rs.getString("abreviatura_v")==null?"":rs.getString("abreviatura_v");
    double cantidadVolumen = rs.getDouble("CANTIDAD_VOLUMEN");
    double cantidadVolumenv = rs.getDouble("CANTIDAD_VOLUMEN_V");
    java.util.Date fechaVencimientoRS = rs.getDate("FECHA_VENCIMIENTO_RS");
    java.util.Date fechaVencimientoRSv = rs.getDate("FECHA_VENCIMIENTO_RS_V");

    fechaVencimientoRS=fechaVencimientoRS==null?new java.util.Date():fechaVencimientoRS;
    fechaVencimientoRSv=fechaVencimientoRSv==null?new java.util.Date():fechaVencimientoRSv;
    
    

    /*String nombreLineaMkt = rs.getString("NOMBRE_LINEAMKT")==null?"":rs.getString("NOMBRE_LINEAMKT");
    String nombreLineaMktv = rs.getString("NOMBRE_LINEAMKT_V")==null?"":rs.getString("NOMBRE_LINEAMKT_V");

    String codProd = rs.getString("cod_prod")==null?"":rs.getString("cod_prod");
    String codProdv = rs.getString("cod_prod_v")==null?"":rs.getString("cod_prod_v");
    String codForma = rs.getString("cod_forma")==null?"":rs.getString("cod_forma");
    String codFormav = rs.getString("cod_forma_v")==null?"":rs.getString("cod_forma_v");
    String codEnvasePrim = rs.getString("cod_envaseprim")==null?"":rs.getString("cod_envaseprim");
    String codEnvasePrimv = rs.getString("cod_envaseprim_v")==null?"":rs.getString("cod_envaseprim_v");
    String volumenPesoEnvasePrim = rs.getString("VOLUMEN_ENVASE_PRIMARIO")==null?"":rs.getString("VOLUMEN_ENVASE_PRIMARIO");
    String volumenPesoEnvasePrimv = rs.getString("VOLUMEN_ENVASE_PRIMARIO_V")==null?"":rs.getString("VOLUMEN_ENVASE_PRIMARIO_V");
    String cantidadProducto = rs.getString("CANTIDAD_COMPPROD")==null?"":rs.getString("CANTIDAD_COMPPROD");
    String cantidadProductov = rs.getString("CANTIDAD_COMPPROD_V")==null?"":rs.getString("CANTIDAD_COMPPROD_V");
    String sabor = rs.getString("cod_sabor")==null?"":rs.getString("cod_sabor");
    String saborv = rs.getString("cod_sabor_v")==null?"":rs.getString("cod_sabor_v");
    String colorPresPrimaria = rs.getString("COD_COLORPRESPRIMARIA")==null?"":rs.getString("COD_COLORPRESPRIMARIA");
    String colorPresPrimariav = rs.getString("COD_COLORPRESPRIMARIA_V")==null?"":rs.getString("COD_COLORPRESPRIMARIA_V");
    //String volumenPesoAproximado = rs.getString("volumen_envaseprim_v")==null?"":rs.getString("volumen_envaseprim_v");
    //String volumenPesoAproximadov = rs.getString("volumen_envaseprim_v")==null?"":rs.getString("volumen_envaseprim_v");
    String nombreProdSemiterminado = rs.getString("nombre_prod_semiterminado")==null?"":rs.getString("nombre_prod_semiterminado");
    String nombreProdSemiterminadov = rs.getString("nombre_prod_semiterminado_v")==null?"":rs.getString("nombre_prod_semiterminado_v");
    String nombreGenerico = rs.getString("NOMBRE_GENERICO")==null?"":rs.getString("NOMBRE_GENERICO");
    String nombreGenericov = rs.getString("NOMBRE_GENERICO_V")==null?"":rs.getString("NOMBRE_GENERICO_V");
    String registroSanitario = rs.getString("REG_SANITARIO")==null?"":rs.getString("REG_SANITARIO");
    String registroSanitario_v = rs.getString("REG_SANITARIO_V")==null?"":rs.getString("REG_SANITARIO_V");
    String lineaMkt = rs.getString("COD_LINEAMKT")==null?"":rs.getString("COD_LINEAMKT");
    String lineaMktv = rs.getString("COD_LINEAMKT_V")==null?"":rs.getString("COD_LINEAMKT_V");
    String categoria = rs.getString("COD_CATEGORIACOMPPROD")==null?"":rs.getString("COD_CATEGORIACOMPPROD");
    String categoriav = rs.getString("COD_CATEGORIACOMPPROD_V")==null?"":rs.getString("COD_CATEGORIACOMPPROD_V");
    String vidaUtil = rs.getString("vida_util")==null?"":rs.getString("vida_util");
    String vidaUtilv = rs.getString("vida_util_v")==null?"":rs.getString("vida_util_v");
    String codEstadoCompProd = rs.getString("COD_ESTADO_COMPPROD")==null?"":rs.getString("COD_ESTADO_COMPPROD");
    String codEstadoCompProdv = rs.getString("COD_ESTADO_COMPPROD_V")==null?"":rs.getString("COD_ESTADO_COMPPROD_V");
    String codTipoProduccion = rs.getString("cod_tipo_produccion")==null?"":rs.getString("cod_tipo_produccion");
    String codTipoProduccionv = rs.getString("cod_tipo_produccion_v")==null?"":rs.getString("cod_tipo_produccion_v");
    String cantidadVolumen = rs.getString("CANTIDAD_VOLUMEN")==null?"":rs.getString("CANTIDAD_VOLUMEN");
    String cantidadVolumenv = rs.getString("CANTIDAD_VOLUMEN_V")==null?"":rs.getString("CANTIDAD_VOLUMEN_V");
    //String abreviaturaVolumen = rs.getString("abreviatura")==null?"":rs.getString("abreviatura");
    //String abreviaturaVolumenv = rs.getString("abreviatura_V")==null?"":rs.getString("abreviatura_V");
    String volumenEnvasePrimario = rs.getString("CANTIDAD_VOLUMEN")==null?"":rs.getString("CANTIDAD_VOLUMEN");
    String volumenEnvasePrimariov = rs.getString("CANTIDAD_VOLUMEN_V")==null?"":rs.getString("CANTIDAD_VOLUMEN_V");
    String concentracionEnvasePrimario = rs.getString("CONCENTRACION_ENVASE_PRIMARIO")==null?"":rs.getString("CONCENTRACION_ENVASE_PRIMARIO");
    String concentracionEnvasePrimariov = rs.getString("CONCENTRACION_ENVASE_PRIMARIO_V")==null?"":rs.getString("CONCENTRACION_ENVASE_PRIMARIO_V");
    String pesoEnvasePrimario = rs.getString("PESO_ENVASE_PRIMARIO")==null?"":rs.getString("PESO_ENVASE_PRIMARIO");
    String pesoEnvasePrimariov = rs.getString("PESO_ENVASE_PRIMARIO_V")==null?"":rs.getString("PESO_ENVASE_PRIMARIO_V");*/

//String estiloModif = "style='background-color:#F7FE2E'";
//String estiloElim = "style='background-color:#FA8258'";
//String estiloAgr = "style='background-color:#01DF3A'";
out.print("<div><b>INFORMACION DE VERSION PRODUCTO SEMITERMINADO</b></div>" +
        "  <table class='outputText1'><tr><td>Modificacion</td>" +
        " <td style='background-color:#F7FE2E;border-color:black;border-style:solid;border-width:thin'>" +
        " &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>" +
        " <td>Eliminacion</td><td style='background-color:#FA8258;border-color:black;border-style:solid;border-width:thin'>" +
        " &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>" +
        " <td>Agregacion</td><td style='background-color:#01DF3A;border-color:black;border-style:solid;border-width:thin'>" +
        " &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr></table> "  +
        " <table border='1' cellpadding='0' cellspacing='0' style='font-family: Verdana, Arial, Helvetica, sans-serif;  font-size: 12px;' >" +        
        " <tbody> " +
        " <tr><td></td><td>Antes</td><td>Despues</td></tr> " +
        "        <tr>" +
        "            <td>Nombre Comercial</td>" +
        "            <td "+(!nombreProd.equals(nombreProdv)?estiloModif:estilo_)+" >"+(nombreProd)+"</td>" +
        "            <td "+(!nombreProd.equals(nombreProdv)?estiloModif:estilo_)+" >"+(nombreProdv)+"</td>" +
        "        </tr>" +
        "        <tr>" +
        "            <td>Forma Farmaceutica</td>" +
        "            <td "+(!nombreForma.equals(nombreFormav)?estiloModif:estilo_)+" >"+(nombreForma)+"</td>" +
        "            <td "+(!nombreForma.equals(nombreFormav)?estiloModif:estilo_)+" >"+(nombreFormav)+"</td>" +
        "        </tr>" +
        "        <tr>" +
        "            <td>Via Administracion</td>" +
        "            <td "+(!nombreViaAdministracionProducto.equals(nombreViaAdministracionProductov)?estiloModif:estilo_)+" >"+(nombreViaAdministracionProducto)+"</td>" +
        "            <td "+(!nombreViaAdministracionProducto.equals(nombreViaAdministracionProductov)?estiloModif:estilo_)+" >"+(nombreViaAdministracionProductov)+"</td>" +
        "        </tr>" +
        "        <tr>" +
        "            <td>Volumen Envase Primario</td>" +
        "            <td "+(cantidadVolumen!=cantidadVolumenv?estiloModif:estilo_)+" >"+(cantidadVolumen)+"<div "+(!abreviatura.equals(abreviaturav)?estiloModif:estilo_)+">"+abreviatura+"</div></td>" +
        "            <td "+(cantidadVolumen!=cantidadVolumenv?estiloModif:estilo_)+" >"+(cantidadVolumenv)+"<div "+(!abreviatura.equals(abreviaturav)?estiloModif:estilo_)+">"+abreviaturav+"</div></td>" +
        "        </tr>" +
        "        <tr>" +        
        "            <td>Tolerancia Voluman a fabricar</td>" +
        "            <td "+(toleranciaVolumenFabricar!=toleranciaVolumenFabricarv?estiloModif:estilo_)+" >"+(toleranciaVolumenFabricar)+"</td>" +
        "            <td "+(toleranciaVolumenFabricar!=toleranciaVolumenFabricarv?estiloModif:estilo_)+" >"+(toleranciaVolumenFabricarv)+"</td>" +
        "        </tr>" +
        "        <tr>" +
        "            <td>Concentracion Envase Primario</td>" +
        "            <td "+(!concentracionEnvasePrimario.equals(concentracionEnvasePrimariov)?estiloModif:estilo_)+" >"+(concentracionEnvasePrimario)+"</td>" +
        "            <td "+(!concentracionEnvasePrimario.equals(concentracionEnvasePrimariov)?estiloModif:estilo_)+" >"+(concentracionEnvasePrimariov)+"</td>" +
        "        </tr>" +
        "        <tr>" +
        "            <td>Peso Envase Primario</td>" +
        "            <td "+(!pesoEnvasePrimario.equals(pesoEnvasePrimariov)?estiloModif:estilo_)+" >"+(pesoEnvasePrimario)+"</td>" +
        "            <td "+(!pesoEnvasePrimario.equals(pesoEnvasePrimariov)?estiloModif:estilo_)+" >"+(pesoEnvasePrimariov)+"</td>" +
        "        </tr>" +
        "        <tr>" +
        "            <td>Color Pres. Primaria</td>" +
        "            <td "+(!colorPresPrimaria.equals(colorPresPrimariav)?estiloModif:estilo_)+" >"+(colorPresPrimaria)+"</td>" +
        "            <td "+(!colorPresPrimaria.equals(colorPresPrimariav)?estiloModif:estilo_)+" >"+(colorPresPrimariav)+"</td>" +
        "        </tr>" +
        "        <tr>" +
        "            <td>Sabor</td>" +
        "            <td "+(!nombreSabor.equals(nombreSaborv)?estiloModif:estilo_)+" >"+(nombreSabor)+"</td>" +
        "            <td "+(!nombreSabor.equals(nombreSaborv)?estiloModif:estilo_)+" >"+(nombreSaborv)+"</td>" +
        "        </tr> " +
        "        <tr>" +
        "            <td>Area Fabricacion</td>" +
        "            <td "+(!nombreAreaEmpresa.equals(nombreAreaEmpresav)?estiloModif:estilo_)+" >"+(nombreAreaEmpresa)+"</td>" +
        "            <td "+(!nombreAreaEmpresa.equals(nombreAreaEmpresav)?estiloModif:estilo_)+" >"+(nombreAreaEmpresav)+"</td>" +
        "        </tr> " +
        "        <tr>" +
        "            <td>Nombre</td>" +
        "            <td "+(!nombreProdSemiterminado.equals(nombreProdSemiterminadov)?estiloModif:estilo_)+" >"+(nombreProdSemiterminado)+"</td>" +
        "            <td "+(!nombreProdSemiterminado.equals(nombreProdSemiterminadov)?estiloModif:estilo_)+" >"+(nombreProdSemiterminadov)+"</td>" +
        "        </tr>" +
        "        <tr>" +
        "            <td>Nombre Generico</td>" +
        "            <td "+(!nombreGenerico.equals(nombreGenericov)?estiloModif:estilo_)+" >"+(nombreGenerico)+"</td>" +
        "            <td "+(!nombreGenerico.equals(nombreGenericov)?estiloModif:estilo_)+" >"+(nombreGenericov)+"</td>" +
        "        </tr>" +



        "        <tr>" +
        "            <td>Envase Primario</td>" +
        "            <td "+(!nombreEnvasePrim.equals(nombreEnvasePrimv)?estiloModif:estilo_)+" >"+(nombreEnvasePrim)+"</td>" +
        "            <td "+(!nombreEnvasePrim.equals(nombreEnvasePrimv)?estiloModif:estilo_)+" >"+(nombreEnvasePrimv)+"</td>" +
        "        </tr>" +
        
        "        <tr>" +
        "            <td>Cantidad Producto</td>" +
        "            <td "+(!cantCompProd.equals(cantCompProdv)?estiloModif:estilo_)+" >"+(cantCompProd)+"</td>" +
        "            <td "+(!cantCompProd.equals(cantCompProdv)?estiloModif:estilo_)+" >"+(cantCompProdv)+"</td>" +
        "        </tr>" +
        
        "        <tr>" +
        "            <td>Registro Sanitario</td>" +
        "            <td "+(!registroSanitario.equals(registroSanitariov)?estiloModif:estilo_)+" >"+(registroSanitario)+"</td>" +
        "            <td "+(!registroSanitario.equals(registroSanitariov)?estiloModif:estilo_)+" >"+(registroSanitariov)+"</td>" +
        "        </tr>" +
        "        <tr>" +
        "            <td>Fecha Vencimiento R.S.</td>" +
        "            <td "+((!sdf.format(fechaVencimientoRS).equals(sdf.format(fechaVencimientoRSv)))?estiloModif:estilo_)+" >"+(sdf.format(fechaVencimientoRS))+"</td>" +
        "            <td "+((!sdf.format(fechaVencimientoRS).equals(sdf.format(fechaVencimientoRSv)))?estiloModif:estilo_)+" >"+(sdf.format(fechaVencimientoRSv))+"</td>" +
        "        </tr>" +
        "        <tr>" +
        "            <td>Linea de Marketing</td>" +
        "            <td "+(!nombreLineaMkt.equals(nombreLineaMktv)?estiloModif:estilo_)+" >"+(nombreLineaMkt)+"</td>" +
        "            <td "+(!nombreLineaMkt.equals(nombreLineaMktv)?estiloModif:estilo_)+" >"+(nombreLineaMktv)+"</td>" +
        "        </tr>" +
        "        <tr>" +
        "            <td>Categoria</td>" +
        "            <td "+(!nombreCategoriaCompProd.equals(nombreCategoriaCompProdv)?estiloModif:estilo_)+" >"+(nombreCategoriaCompProd)+"</td>" +
        "            <td "+(!nombreCategoriaCompProd.equals(nombreCategoriaCompProdv)?estiloModif:estilo_)+" >"+(nombreCategoriaCompProdv)+"</td>" +
        "        </tr>" +
        "        <tr>" +
        "            <td>Vida Util</td>" +
        "            <td "+(!vidaUtil.equals(vidaUtilv)?estiloModif:estilo_)+" >"+(vidaUtil)+"</td>" +
        "            <td "+(!vidaUtil.equals(vidaUtilv)?estiloModif:estilo_)+" >"+(vidaUtilv)+"</td>" +
        "        </tr>" +
        "        <tr>" +
        "            <td>Estado</td>" +
        "            <td "+(!nombreEstadoCompProd.equals(nombreEstadoCompProdv)?estiloModif:estilo_)+" >"+(nombreEstadoCompProd)+"</td>" +
        "            <td "+(!nombreEstadoCompProd.equals(nombreEstadoCompProdv)?estiloModif:estilo_)+" >"+(nombreEstadoCompProdv)+"</td>" +
        "        </tr>" +
        "        <tr>" +
        "            <td>Tipo Produccion</td>" +
        "            <td "+(!nombreTipoProduccion.equals(nombreTipoProduccionv)?estiloModif:estilo_)+" >"+(nombreTipoProduccion)+"</td>" +
        "            <td "+(!nombreTipoProduccion.equals(nombreTipoProduccionv)?estiloModif:estilo_)+" >"+(nombreTipoProduccionv)+"</td>" +
        "        </tr>" +
        
        "    </tbody>" +
        "</table>");
}

//modificacion de empaque secundario
sql = " select cp.cod_compprod,cp.nombre_prod_semiterminado,ep.cod_envaseprim,ep.nombre_envaseprim,       pp.CANTIDAD,       pp.cod_presentacion_primaria," +
        "       tppr.NOMBRE_TIPO_PROGRAMA_PROD,       pp.COD_TIPO_PROGRAMA_PROD,       erf.NOMBRE_ESTADO_REGISTRO,       pp.COD_ESTADO_REGISTRO," +
        "       pp.COD_PRESENTACION_PRIMARIA,modif.cod_presentacion_primaria modif,elim.cod_presentacion_primaria elim" +
        " from PRESENTACIONES_PRIMARIAS pp     inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim = pp.cod_envaseprim" +
        "     inner join componentes_prod cp on cp.cod_compprod = pp.cod_compprod" +
        "     left outer join tipos_programa_produccion tppr on tppr.COD_TIPO_PROGRAMA_PROD = pp.COD_TIPO_PROGRAMA_PROD" +
        "     left outer join ESTADOS_REFERENCIALES erf on erf.COD_ESTADO_REGISTRO = pp.COD_ESTADO_REGISTRO" +
        "	 outer apply(select top 1 pv.COD_PRESENTACION_PRIMARIA from PRESENTACIONES_PRIMARIAS_VERSION pv where pv.COD_COMPPROD = pp.COD_COMPPROD" +
        "            	 and pv.COD_ENVASEPRIM =  pp.COD_ENVASEPRIM and pv.CANTIDAD = pp.CANTIDAD) modif" +
        "     outer apply(select top 1 pv.COD_PRESENTACION_PRIMARIA from PRESENTACIONES_PRIMARIAS_VERSION pv where pv.COD_COMPPROD = pp.COD_COMPPROD) elim" +
        " where pp.COD_COMPPROD = '"+codCompProd+"' and" +
        "      pp.cod_estado_registro = 1" +
        " union all" +
        " select cp.cod_compprod,      cp.nombre_prod_semiterminado,       ep.cod_envaseprim,       ep.nombre_envaseprim,       pp.CANTIDAD," +
        "       pp.cod_presentacion_primaria,       tppr.NOMBRE_TIPO_PROGRAMA_PROD,       pp.COD_TIPO_PROGRAMA_PROD,       erf.NOMBRE_ESTADO_REGISTRO," +
        "       pp.COD_ESTADO_REGISTRO,       pp.COD_PRESENTACION_PRIMARIA,-1,-1" +
        " from PRESENTACIONES_PRIMARIAS_VERSION pp" +
        "     inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim = pp.cod_envaseprim" +
        "     left outer join COMPONENTES_PROD_VERSION cp on cp.cod_compprod = pp.cod_compprod" +
        "     left outer join tipos_programa_produccion tppr on tppr.COD_TIPO_PROGRAMA_PROD = pp.COD_TIPO_PROGRAMA_PROD" +
        "     left outer join ESTADOS_REFERENCIALES erf on erf.COD_ESTADO_REGISTRO = pp.COD_ESTADO_REGISTRO" +
        " where pp.COD_COMPPROD = '"+codCompProd+"' and pp.COD_VERSION = '"+codVersion+"' order by ep.nombre_envaseprim ";

sql = " select cp.cod_compprod, cp.nombre_prod_semiterminado,       ep.cod_envaseprim,       ep.nombre_envaseprim,       pp.CANTIDAD," +
        " pp.cod_presentacion_primaria,       tppr.NOMBRE_TIPO_PROGRAMA_PROD,       pp.COD_TIPO_PROGRAMA_PROD,       erf.NOMBRE_ESTADO_REGISTRO," +
        " pp.COD_ESTADO_REGISTRO,       pp.COD_PRESENTACION_PRIMARIA,       existe.cod_presentacion_primaria existe,       modif.cod_presentacion_primaria modif" +
        " from PRESENTACIONES_PRIMARIAS_VERSION pp     inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim = pp.cod_envaseprim" +
        " inner join COMPONENTES_PROD_VERSION cp on cp.cod_compprod = pp.cod_compprod and cp.COD_VERSION = pp.COD_VERSION " +
        " left outer join tipos_programa_produccion tppr on     tppr.COD_TIPO_PROGRAMA_PROD = pp.COD_TIPO_PROGRAMA_PROD" +
        " left outer join ESTADOS_REFERENCIALES erf on erf.COD_ESTADO_REGISTRO =     pp.COD_ESTADO_REGISTRO" +
        " outer apply( select top 1 pv.COD_PRESENTACION_PRIMARIA  from PRESENTACIONES_PRIMARIAS pv" +
        " where pv.COD_COMPPROD = pp.COD_COMPPROD and pv.COD_ENVASEPRIM = pp.COD_ENVASEPRIM) existe" +
        " outer apply(select top 1 pv.COD_PRESENTACION_PRIMARIA" +
        " from PRESENTACIONES_PRIMARIAS pv" +
        " where pv.COD_COMPPROD = pp.COD_COMPPROD and pv.COD_ENVASEPRIM = pp.COD_ENVASEPRIM and pv.CANTIDAD = pp.CANTIDAD) modif " +
        " where pp.COD_COMPPROD = '"+codCompProd+"' and" +
        " pp.cod_estado_registro = 1 and pp.cod_version ='"+codVersion+"'" +
        " union all" +
        " select cp.cod_compprod,       cp.nombre_prod_semiterminado,       ep.cod_envaseprim,       ep.nombre_envaseprim,       pp.CANTIDAD," +
        "       pp.cod_presentacion_primaria,       tppr.NOMBRE_TIPO_PROGRAMA_PROD,       pp.COD_TIPO_PROGRAMA_PROD,       erf.NOMBRE_ESTADO_REGISTRO," +
        "       pp.COD_ESTADO_REGISTRO,       pp.COD_PRESENTACION_PRIMARIA,       - 1,       - 1" +
        " from PRESENTACIONES_PRIMARIAS pp" +
        "     inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim = pp.cod_envaseprim" +
        "     left outer join COMPONENTES_PROD cp on cp.cod_compprod =pp.cod_compprod" +
        "     left outer join tipos_programa_produccion tppr on tppr.COD_TIPO_PROGRAMA_PROD = pp.COD_TIPO_PROGRAMA_PROD" +
        "     left outer join ESTADOS_REFERENCIALES erf on erf.COD_ESTADO_REGISTRO = pp.COD_ESTADO_REGISTRO" +
        "     where pp.COD_COMPPROD = '"+codCompProd+"'" +
        "     and cast( pp.COD_COMPPROD as varchar)+''+CAST( pp.COD_ENVASEPRIM as varchar) not in(" +
        "     select cast( pv.COD_COMPPROD as varchar)+''+CAST( pv.COD_ENVASEPRIM as varchar)" +
        "     from PRESENTACIONES_PRIMARIAS_VERSION pv where pv.COD_COMPPROD = pp.COD_COMPPROD" +
        "     and pv.COD_ENVASEPRIM = pp.COD_ENVASEPRIM and pv.cod_version = '"+codVersion+"')" +
        "     order by ep.nombre_envaseprim ";

Statement st1 = con.createStatement();
System.out.println("consulta " + sql);
ResultSet rs1 = st1.executeQuery(sql);
out.print("<br/><br/><div><b>INFORMACION DE PRESENTACION PRIMARIA</b></div><table border='1' cellpadding='0' cellspacing='0' style='font-family: Verdana, Arial, Helvetica, sans-serif;  font-size: 12px;'>");
String estiloFila = "";
out.print("<tr><td>ENVASE</td>" +
            "<td>CANTIDAD</td>" +
            "<td>TIPO PROGRAMA PRODUCCION</td>" +
            "<td>ESTADO</td></tr>");
while(rs1.next()){
    
    estiloFila = "";

    if(rs1.getInt("existe")==0)
    estiloFila = estiloAgr;

    if(rs1.getInt("existe")>0 && rs1.getInt("modif")==0)
    estiloFila = estiloModif;

    if(rs1.getInt("existe")<0)
    estiloFila = estiloElim;




    out.print("<tr><td "+estiloFila+">"+rs1.getString("nombre_envaseprim")+"</td>" +
            "<td "+estiloFila+">"+rs1.getInt("cantidad")+"</td>" +
            "<td "+estiloFila+">"+rs1.getString("NOMBRE_TIPO_PROGRAMA_PROD")+"</td>" +
            "<td "+estiloFila+">"+rs1.getString("nombre_estado_registro")+"</td></tr>");
}
out.print("<br/><br/></table cellpadding='0' cellspacing='0'>");
sql = " select cppv.cod_compprod,    p.cod_presentacion,       p.NOMBRE_PRODUCTO_PRESENTACION,       cppv.CANT_COMPPROD," +
        "       e.COD_ESTADO_REGISTRO,       e.NOMBRE_ESTADO_REGISTRO,       t.COD_TIPO_PROGRAMA_PROD," +
        " t.NOMBRE_TIPO_PROGRAMA_PROD,existe.cod_presentacion existe, modif.cod_presentacion modif" +
        " from COMPONENTES_PRESPROD_VERSION cppv" +
        " inner join PRESENTACIONES_PRODUCTO p on p.cod_presentacion = cppv.COD_PRESENTACION" +
        " left outer join ESTADOS_REFERENCIALES e on e.COD_ESTADO_REGISTRO = cppv.COD_ESTADO_REGISTRO" +
        " left outer join TIPOS_PROGRAMA_PRODUCCION t on t.COD_TIPO_PROGRAMA_PROD = cppv.COD_TIPO_PROGRAMA_PROD" +
        " outer apply( select top 1 cppv.cod_presentacion" +
        " from COMPONENTES_PRESPROD  CPP" +
        " where cpp.cod_compprod = cppv.cod_compprod and cpp.cod_presentacion = cppv.cod_presentacion) existe" +
        " outer apply( select top 1 cppv.cod_presentacion from COMPONENTES_PRESPROD CPP" +
        " where cpp.COD_COMPPROD = cppv.COD_COMPPROD and  cpp.cod_presentacion = cppv.cod_presentacion" +
        " and cpp.cant_compprod = cppv.cant_compprod) modif" +
        " where cppv.COD_COMPPROD = '"+codCompProd+"' and cppv.cod_version = '"+codVersion+"'" +
        " union all" +
        " select cpp.cod_compprod,  p.cod_presentacion,       p.NOMBRE_PRODUCTO_PRESENTACION,       cpp.CANT_COMPPROD," +
        "       e.COD_ESTADO_REGISTRO,       e.NOMBRE_ESTADO_REGISTRO,       t.COD_TIPO_PROGRAMA_PROD," +
        "       t.NOMBRE_TIPO_PROGRAMA_PROD,-1,-1 from COMPONENTES_PRESPROD cpp" +
        "     inner join PRESENTACIONES_PRODUCTO p on p.cod_presentacion = cpp.COD_PRESENTACION" +
        "     left outer join ESTADOS_REFERENCIALES e on e.COD_ESTADO_REGISTRO = cpp.COD_ESTADO_REGISTRO" +
        "     left outer join TIPOS_PROGRAMA_PRODUCCION t on t.COD_TIPO_PROGRAMA_PROD = cpp.COD_TIPO_PROGRAMA_PROD" +
        "     and   cast (cpp.COD_COMPPROD as varchar) + '' + CAST (cpp.cod_presentacion as   varchar)" +
        " not in (  select cast (cppr.COD_COMPPROD as varchar) + '' + CAST (cppr.cod_presentacion as varchar)" +
        " from componentes_presprod cppr" +
        " where cppr.COD_COMPPROD = cpp.COD_COMPPROD and cppr.cod_presentacion = cpp.cod_presentacion )" +
        " where cpp.COD_COMPPROD = '"+codCompProd+"' ";
sql = " SELECT cppv.cod_compprod,	p.cod_presentacion,	p.NOMBRE_PRODUCTO_PRESENTACION,	cppv.CANT_COMPPROD,	e.COD_ESTADO_REGISTRO,	e.NOMBRE_ESTADO_REGISTRO," +
        "	t.COD_TIPO_PROGRAMA_PROD,	t.NOMBRE_TIPO_PROGRAMA_PROD,	existe.cod_presentacion existe,	modif.cod_presentacion modif" +
        " FROM	COMPONENTES_PRESPROD_VERSION cppv" +
        " INNER JOIN PRESENTACIONES_PRODUCTO p ON p.cod_presentacion = cppv.COD_PRESENTACION" +
        " LEFT OUTER JOIN ESTADOS_REFERENCIALES e ON e.COD_ESTADO_REGISTRO = cppv.COD_ESTADO_REGISTRO" +
        " LEFT OUTER JOIN TIPOS_PROGRAMA_PRODUCCION t ON t.COD_TIPO_PROGRAMA_PROD = cppv.COD_TIPO_PROGRAMA_PROD" +
        " OUTER apply (	SELECT TOP 1 cppv.cod_presentacion	FROM COMPONENTES_PRESPROD CPP	WHERE		cpp.cod_compprod = cppv.cod_compprod" +
        "	AND cpp.cod_presentacion = cppv.cod_presentacion) existe" +
        " OUTER apply (	SELECT TOP 1 cppv.cod_presentacion	FROM COMPONENTES_PRESPROD CPP	WHERE cpp.COD_COMPPROD = cppv.COD_COMPPROD" +
        "	AND cpp.cod_presentacion = cppv.cod_presentacion	AND cpp.cant_compprod = cppv.cant_compprod) modif" +
        " WHERE	cppv.COD_COMPPROD = '"+codCompProd+"' AND cppv.cod_version = '"+codVersion+"'" +
        " UNION ALL	SELECT cpp.cod_compprod,		p.cod_presentacion,		p.NOMBRE_PRODUCTO_PRESENTACION,		cpp.CANT_COMPPROD,		e.COD_ESTADO_REGISTRO," +
        " e.NOMBRE_ESTADO_REGISTRO,		t.COD_TIPO_PROGRAMA_PROD,		t.NOMBRE_TIPO_PROGRAMA_PROD ,- 1 ,- 1	FROM" +
        " COMPONENTES_PRESPROD cpp	INNER JOIN PRESENTACIONES_PRODUCTO p ON p.cod_presentacion = cpp.COD_PRESENTACION	LEFT OUTER JOIN ESTADOS_REFERENCIALES e ON e.COD_ESTADO_REGISTRO = cpp.COD_ESTADO_REGISTRO" +
        " left outer JOIN TIPOS_PROGRAMA_PRODUCCION t ON t.COD_TIPO_PROGRAMA_PROD = cpp.COD_TIPO_PROGRAMA_PROD" +
        " WHERE  CAST (cpp.COD_COMPPROD AS VARCHAR) + '' + CAST (	cpp.cod_presentacion AS VARCHAR	)" +
        " NOT IN (SELECT CAST (cppr.COD_COMPPROD AS VARCHAR) + '' + CAST ( cppr.cod_presentacion AS VARCHAR)" +
        " FROM componentes_presprod_version cppr WHERE cppr.COD_COMPPROD = '"+codCompProd+"' AND cppr.cod_presentacion = cpp.cod_presentacion" +
        " and cppr.cod_Version = '"+codVersion+"') and cpp.COD_COMPPROD = '"+codCompProd+"'; ";

Statement st2 = con.createStatement();
System.out.println("consulta " + sql);
ResultSet rs2 = st1.executeQuery(sql);
out.print("<br/><br/><div><b>INFORMACION DE PRESENTACION SECUNDARIA</b></div><br/><table border='1' cellpadding='0' cellspacing='0' style='font-family: Verdana, Arial, Helvetica, sans-serif;  font-size: 12px;' >");
estiloFila = "";
out.print("<tr><td>PRESENTACION</td>" +
            "<td>CANTIDAD</td>" +
            "<td>TIPO PROGRAMA PRODUCCION</td>" +
            "<td>ESTADO</td></tr>");
while(rs2.next()){
    estiloFila = "";

    if(rs2.getInt("existe")==0)
    estiloFila = estiloAgr;

    if(rs2.getInt("existe")>0 && rs2.getInt("modif")==0)
    estiloFila = estiloModif;

    if(rs2.getInt("existe")<0)
    estiloFila = estiloElim;

    out.print("<tr><td "+estiloFila+">"+rs2.getString("NOMBRE_PRODUCTO_PRESENTACION")+"</td>" +
            "<td "+estiloFila+">"+rs2.getInt("cant_compprod")+"</td>" +
            "<td "+estiloFila+">"+rs2.getString("NOMBRE_TIPO_PROGRAMA_PROD")+"</td>" +
            "<td "+estiloFila+">"+rs2.getString("nombre_estado_registro")+"</td></tr>");
}
out.print("</table>");
%>


