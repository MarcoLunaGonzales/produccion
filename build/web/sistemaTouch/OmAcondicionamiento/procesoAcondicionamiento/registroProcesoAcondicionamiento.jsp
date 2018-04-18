<%@ page contentType="text/html"%>
<%@ page pageEncoding="UTF-8"%>
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
<%@ page import="java.lang.Math" %>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.GregorianCalendar"%>
<%@ page language="java" import = "org.joda.time.*"%>
<%@ page language="java" import="java.util.*,com.cofar.util.CofarConnection" %>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>

        <script src="../../reponse/js/scripts.js"></script>
        <link rel="STYLESHEET" type="text/css" href="../../reponse/css/foundation.css" />
        <link rel="STYLESHEET" type="text/css" href="../../reponse/css/AtlasWeb.css" />
        <link rel="STYLESHEET" type="text/css" href="../../reponse/css/border-radius.css" />
        <link rel="STYLESHEET" type="text/css" href="../../reponse/css/timePickerCSs.css" />
        <link rel="STYLESHEET" type="text/css" href="../../reponse/css/mensajejs.css" />
        <script src="../../reponse/js/variables.js"></script>
        <script src="../../reponse/js/utiles.js"></script>
        <script src="../../reponse/js/componentesJs.js"></script>
        <script src="../../reponse/js/validaciones.js"></script>
        <script src="../../reponse/js/websql.js"></script>

        <style>
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
            .radioButton {
                margin:0.15em !important;
                height:1.3em !important;
                width:1.3em !important;
                display:inline-block;
                cursor:pointer !important;
            }
            .radioButton + label{
                display: inline-block;

            }
            .radioButton:checked
            {
                height:1.4em !important;
                width:1.4em !important;
            }
            .radioButton:checked + label{
                background-color: #32CD32 !important;
                font-size:1.2em !important;
            }
            li{
                text-align:center !important;
                list-style: none;
                display:table-cell;
            }
        </style>
        <script type="text/javascript">
            var dataMateriales = "";
            function guardarAcondicionamientoAmpollas(aprobacionDepeje, codTipoGuardado)
            {
                iniciarProgresoSistema();
                var contenedor = document.getElementById("dataAcondicionamiento");
                var dataSeguimiento = new Array();
                var dataMateriales = new Array();

                for (var i = 1; (i < contenedor.rows.length && contenedor.rows.length > 1); i++)
                {
                    if (validarRegistroEntero(contenedor.rows[i].cells[4].getElementsByTagName('input')[0]) &&
                            validarFechaRegistro(contenedor.rows[i].cells[1].getElementsByTagName('input')[0]) &&
                            validarSeleccionRegistro(contenedor.rows[i].cells[0].getElementsByTagName('select')[0]) &&
                            validarHoraRegistro(contenedor.rows[i].cells[2].getElementsByTagName('input')[0]) &&
                            validarHoraRegistro(contenedor.rows[i].cells[3].getElementsByTagName('input')[0]) &&
                            validarRegistrosHorasNoNegativas(contenedor.rows[i].cells[2].getElementsByTagName('input')[0], contenedor.rows[i].cells[3].getElementsByTagName('input')[0]))
                    {
                        dataSeguimiento[dataSeguimiento.length] = i;
                        dataSeguimiento[dataSeguimiento.length] = contenedor.rows[i].cells[0].getElementsByTagName('select')[0].value;
                        dataSeguimiento[dataSeguimiento.length] = contenedor.rows[i].cells[1].getElementsByTagName('input')[0].value;
                        dataSeguimiento[dataSeguimiento.length] = contenedor.rows[i].cells[2].getElementsByTagName('input')[0].value;
                        dataSeguimiento[dataSeguimiento.length] = contenedor.rows[i].cells[3].getElementsByTagName('input')[0].value;
                        dataSeguimiento[dataSeguimiento.length] = contenedor.rows[i].cells[4].getElementsByTagName('input')[0].value;
                        dataSeguimiento[dataSeguimiento.length] = getNumeroDehoras((dataSeguimiento[dataSeguimiento.length - 4] + ' ' + dataSeguimiento[dataSeguimiento.length - 3]),
                                (dataSeguimiento[dataSeguimiento.length - 4] + ' ' + dataSeguimiento[dataSeguimiento.length - 2]));
                        var dataMat = contenedor.rows[i].cells[5].getElementsByTagName('table')[0];
                        for (var k = 0; k < dataMat.rows.length; k++)
                        {
                            if (validarRegistroEntero(dataMat.rows[k].cells[1].getElementsByTagName("input")[0]))
                            {

                                if (parseInt(dataMat.rows[k].cells[1].getElementsByTagName("input")[0].value) > 0)
                                {
                                    dataMateriales[dataMateriales.length] = i;
                                    dataMateriales[dataMateriales.length] = contenedor.rows[i].cells[0].getElementsByTagName('select')[0].value;
                                    dataMateriales[dataMateriales.length] = dataMat.rows[k].cells[0].getElementsByTagName("input")[0].value
                                    dataMateriales[dataMateriales.length] = dataMat.rows[k].cells[1].getElementsByTagName("input")[0].value;
                                }
                            } else
                            {
                                terminarProgresoSistema();
                                return false;
                            }
                        }

                    } else
                    {
                        terminarProgresoSistema();
                        return false;
                    }

                }
                var dataEmbalado = crearArrayTablaFechaHora("dataEmbalado", 2);
                if (dataEmbalado == null)
                {
                    terminarProgresoSistema();
                    return null;
                }

                var tablaComplemento = document.getElementById("dataComplementoSaldos");
                var dataComplemento = new Array();
                for (var i = 2; i < tablaComplemento.rows.length; i++)
                {
                    dataComplemento[dataComplemento.length] = tablaComplemento.rows[i].cells[0].getElementsByTagName("input")[0].value;
                    dataComplemento[dataComplemento.length] = tablaComplemento.rows[i].cells[1].getElementsByTagName("input")[0].value;
                }
                ajax = nuevoAjax();
                var peticion = "ajaxGuardarRegistroProcesoAcondicionamiento.jsf?" +
                        "codLote=" + codLoteGeneral + "&noCache=" + Math.random() + "&date=" + (new Date().getTime()).toString() +
                        "&codprogramaProd=" + codProgramaProdGeneral +
                        "&codTipoProgramaProd=" + codTipoProgramaProdGeneral +
                        "&codCompProd=" + codComprodGeneral +
                        "&codFormulaMaestra=" + codFormulaMaestraGeneral +
                        "&codActividadAcond=" + document.getElementById("codActividadAcond").value +
                        "&codActividadEmbalado=" + document.getElementById("codActividadEmbalado").value +
                        "&codTipoGuardado=" + codTipoGuardado +
                        "&codTipoPermiso=" + (codTipoPermiso) +
                        "&codPersonalUsuario=" + codPersonalGeneral +
                        (codTipoPermiso == 12 ? "&observacion=" + document.getElementById("observacion").value : "");

                ajax.open("POST", peticion, true);
                ajax.onreadystatechange = function () {
                    if (ajax.readyState == 4) {
                        if (ajax.responseText == null || ajax.responseText == '')
                        {
                            terminarProgresoSistema();
                            alertJs('No se puede conectar con el servidor, verfique su conexión a internet');
                            if (confirm("Desea guardar la informacion localmente?\nLa informacion del lote no se perdera pero debe de subirla despues"))
                            {
                                sqlConnection.insertarRegistroAuxiliar(document.getElementById("codprogramaProd").value, codLote, 3, ("../registroEtapaLavado/" + peticion), function () {
                                    window.close();
                                });
                            }
                            return false;
                        }
                        if (parseInt(ajax.responseText.split("\n").join("")) == '1')
                        {
                            terminarProgresoSistema();
                            mensajeJs('Se registro la etapa de Acondicionamiento',
                                    function () {
                                        window.close()
                                    });
                            return true;
                        } else
                        {
                            terminarProgresoSistema();
                            alertJs(ajax.responseText.split("\n").join(""));
                            return false;
                        }
                    }
                }
                ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                ajax.send("dataSeguimiento=" + dataSeguimiento + "&dataMateriales=" + dataMateriales +
                        "&dataComplemento=" + dataComplemento + "&dataEmbalado=" + dataEmbalado);

            }
            onerror = errorMessaje;
            function errorMessaje()
            {
                alert('error de javascript');
            }
            function reducirCantidadMateriales(codMaterial, celda)
            {
                console.log(document.getElementById("cantMat" + codMaterial).innerHTML);
            }
            function cambioTipoProduccion()
            {
                var tabla = document.getElementById("dataProducto");
                for (var i = 1; i < tabla.rows.length; i++)
                {
                    tabla.rows[i].cells[3].getElementsByTagName("span")[0].innerHTML = 0;
                    tabla.rows[i].cells[4].getElementsByTagName("span")[0].innerHTML = tabla.rows[i].cells[1].getElementsByTagName("span")[0].innerHTML;
                }
                var tabla2 = document.getElementById("dataAcondicionamiento");
                for (var j = 1; j < tabla2.rows.length; j++)
                {
                    var codTipo = valorCeldaInputCheck(tabla2.rows[j].cells[5]);
                    var cantOtros = parseInt(document.getElementById('cantOtros' + codTipo).innerHTML);
                    var cantMio = parseInt(document.getElementById('cantMio' + codTipo).innerHTML);
                    document.getElementById('cantMio' + codTipo).innerHTML = (cantMio + parseInt(tabla2.rows[j].cells[4].getElementsByTagName('input')[0].value));
                    document.getElementById('cantRes' + codTipo).innerHTML = (parseInt(document.getElementById('timbrados' + codTipo).innerHTML) - (cantMio + parseInt(tabla2.rows[j].cells[4].getElementsByTagName('input')[0].value)));


                }
            }
            function reducirCantidadProducto(celda)
            {
                var tabla = celda.parentNode.parentNode.parentNode;
                var suma = 0;

                for (var i = 1; i < tabla.rows.length; i++)
                {
                    suma += parseInt(tabla.rows[i].cells[4].getElementsByTagName("input")[0].value);
                }
                try
                {
                    document.getElementById('cantRes').innerHTML = (parseInt(document.getElementById('cantProd').innerHTML.split(",").join("")) - suma);
                    document.getElementById('cantUti').innerHTML = suma;
                } catch (interupcion)
                {
                    console.log(interupcion.descripcion);
                }

            }
            function nuevoRegistro(nombreTabla)
            {
                var table = document.getElementById(nombreTabla);
                var fila = table.insertRow(table.rows.length);
                fila.onclick = function () {
                    seleccionarFila(this);
                };
                componentesJs.crearCelda(fila).appendChild(componentesJs.crearSelect(operariosRegistroGeneral));
                componentesJs.crearCelda(fila).appendChild(componentesJs.crearInputFechaDefecto());
                componentesJs.crearCelda(fila).appendChild(componentesJs.crearInputHora1());
                componentesJs.crearCelda(fila).appendChild(componentesJs.crearInputHora2());
                var inputCantidad = componentesJs.crearInputCantidad(0);
                inputCantidad.onkeyup = function () {
                    reducirCantidadProducto(this);
                };
                componentesJs.crearCelda(fila).appendChild(inputCantidad);
                var cellMaterial = fila.insertCell(5);
                cellMaterial.className = "tableCell";
                cellMaterial.align = "center";
                cellMaterial.style.padding = '0px';
                cellMaterial.style.borderBottom = 'none';
                cellMaterial.innerHTML = "<table cellpading='0' cellspacing='0' style='border:none;margin-bottom:0px;width:100%'>" + (dataMateriales) + "</table>";

            }
            function nuevoComplemento()
            {
                var table = document.getElementById("dataComplementoSaldos");
                var fila = table.insertRow(table.rows.length);
                fila.onclick = function () {
                    seleccionarFila(this);
                };
                var inputLote = componentesJs.crearInputCantidad(0);
                inputLote.placeholder = "LOTE";
                componentesJs.crearCelda(fila).appendChild(inputLote);
                componentesJs.crearCelda(fila).appendChild(componentesJs.crearInputCantidad(0));


            }
            function reducirCantidadMat(codMaterial)
            {
                var cantMat = parseInt(document.getElementById("cantMat" + codMaterial).innerHTML);
                console.log('otros' + cantMat);
                var contenedor = document.getElementById("dataAcondicionamiento");
                var dataMateriales = new Array();
                var cantMio = 0;

                for (var i = 1; (i < contenedor.rows.length && contenedor.rows.length > 1); i++)
                {
                    dataMateriales = contenedor.rows[i].cells[5].getElementsByTagName("table")[0];
                    for (var j = 0; j < dataMateriales.rows.length; j++)
                    {
                        if (parseInt(dataMateriales.rows[j].cells[0].getElementsByTagName("input")[0].value) == codMaterial)
                        {
                            cantMio += parseInt(dataMateriales.rows[j].cells[1].getElementsByTagName("input")[0].value)
                        }
                    }

                }
                document.getElementById("cantMatOtros" + codMaterial).innerHTML = cantMio;
                document.getElementById("cantMatRes" + codMaterial).innerHTML = (cantMat - cantMio);
            }
        </script>


    </head>
    <body >
        <div style="margin-top:2%;position:fixed;;width:100%;z-index:5;visibility:hidden" id="divImagen">
            <center><img src="../../reponse/img/load2.gif"  style="z-index:6; "><%--margin-top:2%;position:fixed;--%>
            </center>
        </div>

        <%
            //datos personal
            int codTipoPermiso = Integer.valueOf(request.getParameter("codTipoPermiso"));
            String codAreaEmpresaPersonal = request.getParameter("codAreaEmpresa");
            int codPersonal = Integer.valueOf(request.getParameter("codPersonal"));
            //datos lote
            String codprogramaProd = request.getParameter("codProgramaProd");
            String codTipoProgramaProd = request.getParameter("codTipoProgramaProd");
            String codCompProd = request.getParameter("codCompProd");
            String codLote = request.getParameter("codLote");

            out.println("<script type='text/javascript'>codPersonal=" + codPersonal + ";"
                    + "codTipoPermiso=" + codTipoPermiso + ";</script>");
            System.out.println("JJ  cod_permiso  " + codTipoPermiso);
            int codEstadoHoja = 0;
            out.println("<title>(" + codLote + ")PROCESO DE ACONDICIONAMIENTO</title>");
            String personal = "";
            int codFormulaMaestra = 0;
            int codPersonalCierre = 0;
            String observaciones = "";
            int codPersonalApruebaDespeje = 0;
            Date fechaCierre = new Date();
            char b = 13;
            char c = 10;
            //formato numero
            NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
            DecimalFormat format = (DecimalFormat) nf;
            format.applyPattern("#,##0.00");
            SimpleDateFormat sdfHora = new SimpleDateFormat("HH:mm");
            SimpleDateFormat sdfDias = new SimpleDateFormat("dd/MM/yyyy");
            String indicacionesDespejeLinea = "";
            //out.println("<script>sqlConnection.verificarRegistroPendiente('"+codprogramaProd+"','"+codLote+"',3)</script>");
            //datos propios de la hoja
            int codActividadEmbalado = 0;
            int codActividadAcond = 0;
            int codSeguimientoAcond = 0;
            int codSeguimientoTimbradoES = 0;
            String acondIndicacionesAcondicionamiento = "";
            try {
                Connection con = null;
                con = Util.openConnection(con);
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                StringBuilder consulta = new StringBuilder("select pp.cod_formula_maestra,cp.nombre_prod_semiterminado,ff.nombre_forma,");
                consulta.append(" cp.VIDA_UTIL,pp.CANT_LOTE_PRODUCCION,tpp.NOMBRE_TIPO_PROGRAMA_PROD,");
                consulta.append(" isnull(dpff.ACOND_INDICACIONES_TIMBRADO_EP, '') as ACOND_INDICACIONES_TIMBRADO_EP,");
                consulta.append(" isnull(afm.COD_ACTIVIDAD_FORMULA, 0) as codActividadAcond,");
                consulta.append(" isnull(sal.COD_SEGUIMIENTO_ACONDICIONAMIENTO_LOTE_ACOND, 0) AS COD_SEGUIMIENTO_ACONDICIONAMIENTO_LOTE_ACOND,");
                consulta.append(" ISNULL(sal.COD_PERSONAL_SUPERVISOR, 0) AS COD_PERSONAL_SUPERVISOR,ISNULL(sal.OBSERVACIONES, '') AS OBSERVACIONES,");
                consulta.append(" sal.FECHA_CIERRE,ISNULL(stea.COD_SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND, 0) AS COD_SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND,");
                consulta.append(" ISNULL(dpff.ACOND_INDICACIONES_DESPEJE_LINEA, '') as ACOND_INDICACIONES_DESPEJE_LINEA,");
                consulta.append(" sal.COD_PERSONAL_APRUEBA_DESPEJE,ISNULL(dpff.ACOND_INDICACIONES_ACONDICIONAMIENTO, '') as ACOND_INDICACIONES_ACONDICIONAMIENTO");
                consulta.append(" ,isnull(afm1.COD_ACTIVIDAD_FORMULA,0) as codActividadEmbalado");
                consulta.append(" from PROGRAMA_PRODUCCION pp inner join componentes_prod cp on ");
                consulta.append(" cp.COD_COMPPROD=pp.COD_COMPPROD ");
                consulta.append(" inner join FORMAS_FARMACEUTICAS ff on ff.cod_forma=cp.COD_FORMA");
                consulta.append(" inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                consulta.append(" left outer join DESCRIPCION_PROCESOS_FORMA_FARMACEUTICA dpff on dpff.COD_FORMA=cp.COD_FORMA");
                consulta.append(" left outer join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_FORMULA_MAESTRA= pp.COD_FORMULA_MAESTRA");
                consulta.append(" and afm.COD_AREA_EMPRESA = 84 and afm.COD_ACTIVIDAD = 317 and afm.COD_PRESENTACION = 0");
                consulta.append(" left outer join ACTIVIDADES_FORMULA_MAESTRA afm1 on afm1.COD_FORMULA_MAESTRA= pp.COD_FORMULA_MAESTRA");
                consulta.append(" and afm1.COD_AREA_EMPRESA = 84 and afm1.COD_ACTIVIDAD = 101 and afm1.COD_PRESENTACION = 0");
                consulta.append(" LEFT OUTER JOIN SEGUIMIENTO_ACONDICIONAMIENTO_LOTE_ACOND sal on sal.cod_lote = pp.COD_LOTE_PRODUCCION");
                consulta.append(" and sal.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD and pp.COD_COMPPROD=sal.COD_COMPPROD");
                consulta.append(" AND PP.COD_TIPO_PROGRAMA_PROD=sal.COD_TIPO_PROGRAMA_PROD");
                consulta.append(" left OUTER join SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND stea on stea.COD_LOTE=pp.COD_LOTE_PRODUCCION");
                consulta.append(" and stea.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and stea.COD_COMPPROD=pp.COD_COMPPROD");
                consulta.append(" and stea.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                consulta.append(" where pp.COD_LOTE_PRODUCCION='" + codLote + "'");
                consulta.append(" and pp.COD_PROGRAMA_PROD=").append(codprogramaProd);
                consulta.append(" and pp.COD_COMPPROD=").append(codCompProd);
                consulta.append(" and pp.COD_TIPO_PROGRAMA_PROD=").append(codTipoProgramaProd);
                System.out.println("consulta cargar datos del lote " + consulta.toString());
                ResultSet res = st.executeQuery(consulta.toString());
                if (res.next()) {
                    acondIndicacionesAcondicionamiento = res.getString("ACOND_INDICACIONES_ACONDICIONAMIENTO");
                    codPersonalApruebaDespeje = res.getInt("COD_PERSONAL_APRUEBA_DESPEJE");
                    indicacionesDespejeLinea = res.getString("ACOND_INDICACIONES_DESPEJE_LINEA");
                    fechaCierre = (res.getTimestamp("FECHA_CIERRE") != null ? res.getTimestamp("FECHA_CIERRE") : new Date());
                    codPersonalCierre = res.getInt("COD_PERSONAL_SUPERVISOR");
                    observaciones = res.getString("OBSERVACIONES");
                    codSeguimientoAcond = res.getInt("COD_SEGUIMIENTO_ACONDICIONAMIENTO_LOTE_ACOND");
                    codSeguimientoTimbradoES = res.getInt("COD_SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND");
                    codActividadAcond = res.getInt("codActividadAcond");
                    codActividadEmbalado = res.getInt("codActividadEmbalado");
                    codFormulaMaestra = res.getInt("cod_formula_maestra");
                    System.out.println("codActividadAcond  "+codActividadAcond);
                    if (codActividadAcond == 0) {
                        out.println("<script type='text/javascript'>alert('No se encuentran asociada la actividad: ACONDICIONAMIENTO');window.close();</script>");
                    }

        %>

    <section class="main">
        <div class="row"  style="margin-top:5px" >
            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                <div class="row">
                    <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                        <label  class="inline">PROCESO DE ACONDICIONAMIENTO</label>
                    </div>
                </div>
                <div class="row" >

                    <div  class="divContentClass large-12 medium-12 small-12 columns">

                        <table style="width:96%;margin-top:2%" cellpadding="0px" cellspacing="0px">
                            <tr>
                                <td class="tableHeaderClass" style="text-align:center">
                                    <span class="textHeaderClass">Lote</span>
                                </td>
                                <td class="tableHeaderClass" style="text-align:center;">
                                    <span class="textHeaderClass">Tam. Lote</span>
                                </td>
                                <td class="tableHeaderClass" style="text-align:center">
                                    <span class="textHeaderClass">Producto</span>
                                </td>
                                <td class="tableHeaderClass" style="text-align:center">
                                    <span class="textHeaderClass">Forma Farmaceútica</span>
                                </td>
                                <td class="tableHeaderClass" style="text-align:center">
                                    <span class="textHeaderClass">Presentación</span>
                                </td>
                            </tr>

                            <tr >
                                <td class="tableCell" style="text-align:center">
                                    <span class="textHeaderClassBody"><%=codLote%></span>
                                </td>
                                <td class="tableCell" style="text-align:center;">
                                    <span class="textHeaderClassBody"><%=(res.getInt("CANT_LOTE_PRODUCCION"))%></span>
                                </td>
                                <td class="tableCell" style="text-align:center">
                                    <span class="textHeaderClassBody"><%=res.getString("nombre_prod_semiterminado")%></span>
                                </td>
                                <td class="tableCell" style="text-align:center">
                                    <span class="textHeaderClassBody"><%=res.getString("nombre_forma")%></span>
                                </td>
                                <td class="tableCell" style="text-align:center">
                                    <span class="textHeaderClassBody"><%=res.getString("NOMBRE_TIPO_PROGRAMA_PROD")%></span>
                                </td>
                            </tr>
                        </table>


                    </div>
                </div>
            </div>
        </div>
        <%
            }
            personal = UtilidadesTablet.operariosAreaProduccionAcondicionamientoSelect(st, codTipoPermiso, codPersonal);
            out.println("<script type='text/javascript'>"
                    + "fechaSistemaGeneral='" + sdfDias.format(new Date()) + "';"
                    + "codPersonalGeneral=" + codPersonal + ";"
                    + "codProgramaProdGeneral='" + codprogramaProd + "';"
                    + "codLoteGeneral='" + codLote + "';"
                    + "operariosRegistroGeneral=\"" + personal + "\";"
                    + "codComprodGeneral='" + codCompProd + "';"
                    + "codTipoProgramaProdGeneral='" + codTipoProgramaProd + "';"
                    + "codFormulaMaestraGeneral='" + codFormulaMaestra + "';"
                    + "codTipoPermiso=" + codTipoPermiso + ";</script>");
        %>
        <div class="row"  style="margin-top:5px" >
            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                <div class="row">
                    <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                        <label  class="inline">PROCESO DE ACONDICIONAMIENTO</label>
                    </div>
                </div>
                <div class="row" >

                    <div  class="divContentClass large-12 medium-12 small-12 columns" style="padding-top:1em;">
                        <%=(acondIndicacionesAcondicionamiento)%>
                        <div class="row">
                            <div  class="large-12 medium-12 small-12 columns" style="padding-top:1em;">
                                <center>
                                    <table style='border:none;width:100%;margin-top:4px;' id='dataTiposProgProd' cellpadding='0' cellspacing='0'>
                                        <tr>
                                            <td class='tableHeaderClass prim' style='text-align:center;'  ><span class='textHeaderClass' >MATERIAL</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass' >CANTIDAD<BR>MATERIAL<BR> TIMBRADO</span></td>
                                            <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass' >CANTIDAD<BR>UTILIZADA</span></td>

                                            <td class='tableHeaderClass ult' style='text-align:center;' ><span class='textHeaderClass' >CANTIDAD RESTANTE</span></td>
                                        </tr>
                                        <%
                                            consulta = new StringBuilder("SELECT s.COD_MATERIAL,m.NOMBRE_MATERIAL,SUM (s.CANTIDAD_TIMBRADA) AS cantidadTimbrada");
                                            consulta.append(",(select sum(s1.CANTIDAD) from SEGUIMIENTO_ACONDICIONAMIENTO_LOTE_ACOND_MATERIALES s1");
                                            consulta.append(" where s1.COD_MATERIAL = s.COD_MATERIAL and s1.COD_SEGUIMIENTO_ACONDICIONAMIENTO_LOTE_ACOND = '").append(codSeguimientoAcond).append("') as cantidadUtilizada");
                                            consulta.append(" FROM SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND_MATERIALES s");
                                            consulta.append(" INNER JOIN MATERIALES m ON s.COD_MATERIAL = m.COD_MATERIAL");
                                            consulta.append(" WHERE s.COD_SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND=").append(codSeguimientoTimbradoES);
                                            consulta.append(" and s.CANTIDAD_TIMBRADA>0");
                                            consulta.append(" group by s.COD_MATERIAL,m.NOMBRE_MATERIAL");
                                            consulta.append(" order by m.NOMBRE_MATERIAL");
                                            System.out.println("consulta materiales utilizados " + consulta.toString());
                                            res = st.executeQuery(consulta.toString());
                                            String innerHTMLMateriales = "";
                                            while (res.next()) {
                                                out.println("<tr >"
                                                        + "<td class='tableCell'  style='text-align:center'><span style='font-weight:normal' class='textHeaderClassBody'>" + res.getString("NOMBRE_MATERIAL") + "</span></td>"
                                                        + "<td class='tableCell'  style='text-align:center;'><span style='font-weight:normal' class='textHeaderClassBody' id='cantMat" + res.getInt("COD_MATERIAL") + "'>" + res.getInt("cantidadTimbrada") + "</span></td>"
                                                        + "<td class='tableCell'  style='text-align:center;'><span style='font-weight:normal' class='textHeaderClassBody' id='cantMatOtros" + res.getInt("COD_MATERIAL") + "'>" + res.getInt("cantidadUtilizada") + "</span></td>"
                                                        + "<td class='tableCell'  style='text-align:center;'><span style='font-weight:normal' class='textHeaderClassBody' id='cantMatRes" + res.getInt("COD_MATERIAL") + "'>" + (res.getInt("cantidadTimbrada") - res.getInt("cantidadUtilizada")) + "</span></td>"
                                                        + "</tr>");
                                                innerHTMLMateriales += "<tr >"
                                                        + "<td class='tableCell'  style='text-align:center;border-top:none;border-left:none'><input type='hidden' value='" + res.getInt("COD_MATERIAL") + "'/>"
                                                        + "<span style='font-weight:normal' class='textHeaderClassBody'>" + res.getString("NOMBRE_MATERIAL") + "</span></td>"
                                                        + "<td class='tableCell'  style='text-align:center;border-top:none;border-left:none;border-right:none'>"
                                                        + "<input type='tel' style='width:4em' onkeyup='reducirCantidadMat(" + res.getInt("COD_MATERIAL") + ");' value='0'/></td>"
                                                        + "</tr>";
                                            }
                                            out.println("<script>dataMateriales=\"" + innerHTMLMateriales + "\";</script>");
                                        %>
                                    </table>
                                </center>
                            </div>
                            <div  class="large-12 medium-12 small-12 columns" style="padding-top:1em;">
                                <table style='border:none;width:100%;margin-top:4px;' id='dataProducto' cellpadding='0' cellspacing='0'>
                                    <tr>
                                        <td class='tableHeaderClass prim' style='text-align:center;' ><span class='textHeaderClass' >CANTIDAD<BR>PRODUCTO<BR>TIMBRADO</span></td>
                                        <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass' >CANTIDAD<BR>UTILIZADA</span></td>
                                        <td class='tableHeaderClass ult' style='text-align:center;' ><span class='textHeaderClass' >CANTIDAD RESTANTE</span></td>
                                    </tr>
                                    <%
                                        consulta = new StringBuilder("SELECT SUM(sppp.UNIDADES_PRODUCIDAS) as unidadesProducidas");
                                        consulta.append(" ,(select sum(s.UNIDADES_PRODUCIDAS) from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s where s.COD_COMPPROD=sppp.COD_COMPPROD");
                                        consulta.append("  and s.COD_PROGRAMA_PROD=sppp.COD_PROGRAMA_PROD and s.COD_LOTE_PRODUCCION=sppp.COD_LOTE_PRODUCCION");
                                        consulta.append("  and s.COD_TIPO_PROGRAMA_PROD=sppp.COD_TIPO_PROGRAMA_PROD");
                                        consulta.append("  and s.COD_ACTIVIDAD_PROGRAMA='").append(codActividadAcond).append("') as cantidadUtilizada");
                                        consulta.append(" FROM SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp");
                                        consulta.append(" inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA =");
                                        consulta.append(" sppp.COD_ACTIVIDAD_PROGRAMA and afm.COD_AREA_EMPRESA = 84 and");
                                        consulta.append(" afm.COD_ACTIVIDAD = '300'");
                                        consulta.append(" where sppp.COD_LOTE_PRODUCCION = '").append(codLote).append("'");
                                        consulta.append(" and sppp.COD_PROGRAMA_PROD = ").append(codprogramaProd);
                                        consulta.append(" and sppp.COD_TIPO_PROGRAMA_PROD=").append(codTipoProgramaProd);
                                        consulta.append(" and sppp.COD_COMPPROD=").append(codCompProd);
                                        consulta.append(" group by sppp.COD_LOTE_PRODUCCION,sppp.COD_PROGRAMA_PROD,sppp.COD_TIPO_PROGRAMA_PROD,sppp.COD_COMPPROD");

                                        System.out.println("consulta timbrada " + consulta.toString());
                                        res = st.executeQuery(consulta.toString());
                                        Statement stDetalle = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                        ResultSet resDetalle = null;
                                        while (res.next()) {
                                            out.println("<tr >");
                                            out.println("<td class='tableCell'  style='text-align:center'><span style='font-weight:normal' id='cantProd' class='textHeaderClassBody'>" + nf.format(res.getInt("unidadesProducidas")) + "</span></td>");
                                            out.println("<td class='tableCell'  style='text-align:center'><span style='font-weight:normal' id='cantUti' class='textHeaderClassBody'>" + nf.format(res.getInt("cantidadUtilizada")) + "</span></td>");
                                            out.println("<td class='tableCell'  style='text-align:center'><span style='font-weight:normal' id='cantRes' class='textHeaderClassBody'>" + nf.format(res.getInt("unidadesProducidas") - res.getInt("cantidadUtilizada")) + "</span></td>"
                                                    + "</tr>");
                                        }
                                    %>
                                </table>
                            </div>
                        </div>
                        <center>
                            <div class="row" style="margin-top:1em;">
                                <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns">
                                    <table style="border:none;width:100%;margin-top:4px;" id="dataAcondicionamiento" cellpadding="0px" cellspacing="0px">

                                        <%
                                            out.println("<tr><td class='tableHeaderClass prim' style='text-align:center;'  ><span class='textHeaderClass' >PERSONAL</span></td>"
                                                    + " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass' >FECHA</span></td>"
                                                    + " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass' >HORA<br> INICIO</span></td>"
                                                    + " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass' '>HORA<br> FINAL</span></td>"
                                                    + " <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass' >CANT<BR>ACOND</span></td>"
                                                    + " <td class='tableHeaderClass ult' style='text-align:center;' colspan='2'><span class='textHeaderClass' >MATERIAL<BR>UTILIZADO</span></td>"
                                                    + "</tr>");
                                            consulta = new StringBuilder("SELECT sppp.COD_PERSONAL,sppp.COD_REGISTRO_ORDEN_MANUFACTURA,sppp.COD_REGISTRO_ORDEN_MANUFACTURA,");
                                            consulta.append(" sppp.FECHA_INICIO,sppp.FECHA_FINAL,sppp.UNIDADES_PRODUCIDAS,sppp.COD_TIPO_PROGRAMA_PROD");
                                            consulta.append(" FROM SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp where ");
                                            consulta.append(" sppp.COD_PROGRAMA_PROD=").append(codprogramaProd);
                                            consulta.append(" and sppp.COD_LOTE_PRODUCCION='").append(codLote).append("'");
                                            consulta.append(" and sppp.COD_COMPPROD=").append(codCompProd);
                                            consulta.append(" and sppp.COD_TIPO_PROGRAMA_PROD=").append(codTipoProgramaProd);
                                            consulta.append(" and sppp.COD_ACTIVIDAD_PROGRAMA=").append(codActividadAcond);
                                            if (codTipoPermiso <= 10) {
                                                consulta.append(" and sppp.COD_PERSONAL=").append(codPersonal);
                                            }
                                            consulta.append(" order by sppp.COD_REGISTRO_ORDEN_MANUFACTURA");
                                            System.out.println("consulta detalle " + consulta.toString());
                                            res = st.executeQuery(consulta.toString());
                                            while (res.next()) {
                                                out.println("<tr onclick=\"seleccionarFila(this);\"><td class='tableCell'  style='text-align:center'>"
                                                        + "<select  id='pTimn" + res.getRow() + "'>" + personal + "</select>"
                                                        + "<script>pTimn" + res.getRow() + ".value='" + res.getInt("COD_PERSONAL") + "';</script>"
                                                        + "</td> <td class='tableCell'  style='text-align:center'>"
                                                        + "<input onclick='seleccionarDatePickerJs(this);'  type='text' value='" + sdfDias.format(res.getTimestamp("FECHA_INICIO")) + "' style='width:6em;display:inherit;' id='fecha" + res.getRow() + "n'/>"
                                                        + " </td> <td class='tableCell' style='text-align:center;' align='center'>"
                                                        + " <input  type='text' onclick='seleccionarHora(this);'  id='fechaIniAmpolla" + res.getRow() + "n' value='" + sdfHora.format(res.getTimestamp("FECHA_INICIO")) + "' style='width:4em;display:inherit;'/>"
                                                        + " </td> <td class='tableCell'  style='text-align:center;' align='center'>"
                                                        + " <input  type='text'  onclick='seleccionarHora(this);' id='fechaFinAmpolla" + res.getRow() + "n' value='" + sdfHora.format(res.getTimestamp("FECHA_FINAL")) + "' style='width:4em;display:inherit;'/></td >"
                                                        + "</td>"
                                                        + "<td class='tableCell'  style='text-align:center !important;' align='center'><input  type='tel'   value='" + res.getInt("UNIDADES_PRODUCIDAS") + "' style='width:5em;display:inherit;' onkeyup='reducirCantidadProducto(this)'/></td>"
                                                        + " <td class='tableCell' style='text-align:center;padding:0px;margin-bottom:0px;border-bottom:none' align='center'>"
                                                        + "<table cellpading='0' cellspacing='0' style='border:none;margin-bottom:0px;width:100%'>");
                                                consulta = new StringBuilder("SELECT s.COD_MATERIAL,m.NOMBRE_MATERIAL,SUM (s.CANTIDAD_TIMBRADA) AS cantidadTimbrada,sal.CANTIDAD");
                                                consulta.append(" FROM SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND_MATERIALES s ");
                                                consulta.append(" INNER JOIN MATERIALES m ON s.COD_MATERIAL = m.COD_MATERIAL");
                                                consulta.append(" left outer join SEGUIMIENTO_ACONDICIONAMIENTO_LOTE_ACOND_MATERIALES sal on");
                                                consulta.append(" sal.COD_MATERIAL=m.COD_MATERIAL and sal.COD_PERSONAL='" + res.getInt("COD_PERSONAL") + "'");
                                                consulta.append(" and sal.COD_REGISTRO_ORDEN_MANUFACTURA=").append(res.getInt("COD_REGISTRO_ORDEN_MANUFACTURA"));
                                                consulta.append(" and sal.COD_SEGUIMIENTO_ACONDICIONAMIENTO_LOTE_ACOND=").append(codSeguimientoAcond);
                                                consulta.append(" WHERE s.COD_SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND=").append(codSeguimientoTimbradoES);
                                                consulta.append(" and s.CANTIDAD_TIMBRADA>0");
                                                consulta.append(" group by s.COD_MATERIAL,m.NOMBRE_MATERIAL,sal.CANTIDAD");
                                                consulta.append(" order by m.NOMBRE_MATERIAL");
                                                System.out.println("consulta materiales " + consulta.toString());
                                                resDetalle = stDetalle.executeQuery(consulta.toString());
                                                while (resDetalle.next()) {
                                                    out.println("<tr >"
                                                            + "<td class='tableCell'  style='text-align:center;border-top:none;border-left:none'><input type='hidden' value='" + resDetalle.getInt("COD_MATERIAL") + "'/>"
                                                            + "<span style='font-weight:normal' class='textHeaderClassBody'>" + resDetalle.getString("NOMBRE_MATERIAL") + "</span></td>"
                                                            + "<td class='tableCell'  style='text-align:center;border-top:none;border-left:none;border-right:none' onkeyup='reducirCantidadMat(" + resDetalle.getInt("COD_MATERIAL") + ");'><input  type='tel' style='width:4em;' value='" + resDetalle.getInt("CANTIDAD") + "'/></td>"
                                                            + "</tr>");
                                                }
                                                out.println(" </table></td></tr>");
                                            }


                                        %>
                                    </table>
                                    <div class='row' ><div class='large-5 medium-5 small-4 columns' style=''>&nbsp;</div><div class='large-1 medium-1 small-2 columns' >
                                            <button  class='small button succes radius buttonMas' onclick="nuevoRegistro('dataAcondicionamiento')">+</button>
                                        </div><div class='large-1 medium-1 small-2 columns'>
                                            <button class='small button succes radius buttonMenos' onclick="eliminarRegistroTabla('dataAcondicionamiento');">-</button></div>
                                        <div class='large-5 medium-5 small-4 columns' style=''>&nbsp;</div></div>
                                    <table style="border:none;width:100%;margin-top:4px;" id="dataEmbalado" cellpadding="0px" cellspacing="0px">
                                        <tr>
                                            <td class="tableHeaderClass prim ult" colspan="6"><span class="textHeaderClass">Embalado de producto</span></td>
                                        </tr>
                                        <tr>
                                            <td class="tableHeaderClass"><span class="textHeaderClass">Personal</span></td>
                                            <td class="tableHeaderClass"><span class="textHeaderClass">Fecha</span></td>
                                            <td class="tableHeaderClass"><span class="textHeaderClass">Hora<br>Inicio</span></td>
                                            <td class="tableHeaderClass"><span class="textHeaderClass">Hora<br>Final</span></td>
                                            <td class="tableHeaderClass"><span class="textHeaderClass">Horas<br>Hombre</span></td>
                                            <td class="tableHeaderClass"><span class="textHeaderClass">Cantidad</span></td>
                                        </tr>
                                        <%                                         consulta = new StringBuilder("SELECT sppp.COD_PERSONAL,sppp.COD_REGISTRO_ORDEN_MANUFACTURA,");
                                            consulta.append(" ISNULL(sppp.UNIDADES_PRODUCIDAS, 0) as UNIDADES_PRODUCIDAS,sppp.FECHA_INICIO,");
                                            consulta.append(" sppp.FECHA_FINAL, sppp.HORAS_HOMBRE, sppp.COD_LOTE_PRODUCCION");
                                            consulta.append(" FROM  SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp ");
                                            consulta.append(" where sppp.COD_LOTE_PRODUCCION = '").append(codLote).append("'");
                                            consulta.append(" and  sppp.COD_PROGRAMA_PROD = ").append(codprogramaProd);
                                            consulta.append(" and sppp.COD_FORMULA_MAESTRA = ").append(codFormulaMaestra);
                                            consulta.append(" and sppp.COD_ACTIVIDAD_PROGRAMA = ").append(codActividadEmbalado);
                                            consulta.append(" and sppp.COD_TIPO_PROGRAMA_PROD = ").append(codTipoProgramaProd);
                                            consulta.append(" and sppp.COD_COMPPROD=").append(codCompProd);
                                            if (codTipoPermiso <= 10) {
                                                consulta.append(" and sppp.COD_PERSONAL=").append(codPersonal);
                                            }
                                            consulta.append(" order by sppp.FECHA_INICIO");
                                            System.out.println("consulta cargar seguimiento ampollas " + consulta.toString());
                                            res = st.executeQuery(consulta.toString());
                                            while (res.next()) {
                                        %>
                                        <tr onclick="seleccionarFila(this);">
                                            <td class="tableCell"  style="text-align:center">
                                                <select  id="codEmbalado<%=(res.getRow())%>"><%out.println(personal);%></select>
                                                <%
                                                    out.println("<script>codEmbalado" + res.getRow() + ".value='" + res.getInt("COD_PERSONAL") + "';</script>");
                                                %>
                                            </td>
                                            <td class="tableCell"  style="text-align:center;">
                                                <input  type="tel" value="<%=(res.getTimestamp("FECHA_INICIO") != null ? sdfDias.format(res.getTimestamp("FECHA_INICIO")) : "")%>" style="width:7em" id="fechap<%=(res.getRow())%>" onclick="seleccionarDatePickerJs(this)"/>
                                            </td>
                                            <td class="tableCell"  style="text-align:center;" align="center">
                                                <input  type="tel" onclick='seleccionarHora(this);' id="fechaIniAmpolla<%=(res.getRow())%>" value="<%=(res.getTimestamp("FECHA_INICIO") != null ? sdfHora.format(res.getTimestamp("FECHA_INICIO")) : "")%>" style="width:6em;"/>
                                            </td>
                                            <td class="tableCell"  style="text-align:center;" align="center">
                                                <input  type="tel" onclick='seleccionarHora(this);' id="fechaFinAmpolla<%=(res.getRow())%>" value="<%=(res.getTimestamp("FECHA_INICIO") != null ? sdfHora.format(res.getTimestamp("FECHA_FINAL")) : "")%>" style="width:6em;"/>
                                            </td >
                                            <td class="tableCell" style="text-align:center;" align="center">
                                                <span class="tableHeaderClassBody"><%=(nf.format(res.getDouble("HORAS_HOMBRE")))%></span>
                                            </td>
                                            <td class="tableCell"  style="text-align:center;" align="center">
                                                <input   type="tel"   value="<%=(res.getInt("UNIDADES_PRODUCIDAS"))%>" style="width:6em;display:inherit;"/>
                                            </td>
                                        </tr>
                                        <%
                                            }
                                        %>
                                    </table>

                                    <div class='row' ><div class='large-5 medium-5 small-4 columns' style=''>&nbsp;</div><div class='large-1 medium-1 small-2 columns' >
                                            <button  class='small button succes radius buttonMas' onclick="componentesJs.crearRegistroTablaFechaHora('dataEmbalado')">+</button>
                                        </div><div class='large-1 medium-1 small-2 columns'>
                                            <button class='small button succes radius buttonMenos' onclick="eliminarRegistroTabla('dataEmbalado');">-</button></div>
                                        <div class='large-5 medium-5 small-4 columns' style=''>&nbsp;</div></div>
                                </div>
                            </div>
                            <table style='border:none;width:60%;margin-top:4px;' id='dataComplementoSaldos' cellpadding='0' cellspacing='0'>
                                <tr>
                                    <td class='tableHeaderClass prim ult' style='text-align:center;' colspan="2" ><span class='textHeaderClass' >COMPLEMENTO DE SALDOS</span></td>
                                </tr>
                                <tr>
                                    <td class='tableHeaderClass' style='text-align:center;'  ><span class='textHeaderClass' >DEL LOTE</span></td>
                                    <td class='tableHeaderClass' style='text-align:center;' ><span class='textHeaderClass' >CANTIDAD</span></td>
                                </tr>
                                <%
                                    consulta = new StringBuilder("select sal.COD_LOTE_PRODUCCION,sal.CANTIDAD_COMPLEMENTO");
                                    consulta.append(" from SEGUIMIENTO_ACONDICIONAMIENTO_LOTE_ACOND_COMPL sal ");
                                    consulta.append(" where sal.COD_SEGUIMIENTO_ACONDICIONAMIENTO_LOTE_ACOND=").append(codSeguimientoAcond);
                                    consulta.append(" order by sal.COD_LOTE_PRODUCCION");
                                    res = st.executeQuery(consulta.toString());
                                    while (res.next()) {
                                        out.println("<tr>"
                                                + "<td class='tableCell' style='text-align:center;'  ><input type='tel' value='" + res.getString("COD_LOTE_PRODUCCION") + "'/></td>"
                                                + "<td class='tableCell' style='text-align:center;'  ><input type='tel' value='" + res.getInt("CANTIDAD_COMPLEMENTO") + "'/></td>"
                                                + "</tr>");
                                    }
                                %>
                            </table>
                            <div class='row' >
                                <div class='large-5 medium-5 small-4 columns' style=''>&nbsp;</div><div class='large-1 medium-1 small-2 columns' >
                                    <button  class='small button succes radius buttonMas' onclick="nuevoComplemento()">+</button>
                                </div><div class='large-1 medium-1 small-2 columns'>
                                    <button class='small button succes radius buttonMenos' onclick="eliminarRegistroTabla('dataComplementoSaldos');">-</button></div>
                                <div class='large-5 medium-5 small-4 columns' style=''>&nbsp;</div>
                            </div>
                            <input type="hidden" value="<%=(codPersonalCierre)%>" id="cerrado"/>
                            <%
                                if (codTipoPermiso == 12) {
                                    consulta = new StringBuilder("select (p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombrePersonal");
                                    consulta.append(" from PERSONAL p");
                                    consulta.append(" where p.COD_PERSONAL=").append(codPersonalCierre > 0 ? codPersonalCierre : codPersonal);
                                    res = st.executeQuery(consulta.toString());
                                    String nombrePersonalAprueba = "";
                                    if (res.next()) {
                                        nombrePersonalAprueba = res.getString("nombrePersonal");
                                    }
                            %>
                            <table style="width:80%;margin-top:2px;border-bottom:solid #a80077 1px;" id="datosAdicionales" cellpadding="0px" cellspacing="0px" >
                                <tr >
                                    <td class="tableHeaderClass" style="text-align:center" colspan="3">
                                        <span class="textHeaderClass">APROBACION</span>
                                    </td>
                                </tr>
                                <tr >
                                    <td style="border-left:solid #a80077 1px;text-align:left">
                                        <span >JEFE DE AREA:</span>
                                    </td>
                                    <td style="border-right:solid #a80077 1px;text-align:left">
                                        <span class="textHeaderClassBody" style="font-weight:normal;"><%=(nombrePersonalAprueba)%></span>
                                    </td>

                                </tr>
                                <tr>
                                    <td style="border-left:solid #a80077 1px;text-align:left">
                                        <span >Fecha:</span>
                                    </td>

                                    <td style="border-right:solid #a80077 1px;text-align:left">
                                        <span id="fecha" ><%=sdfDias.format(fechaCierre)%></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="border-left:solid #a80077 1px;text-align:left">
                                        <span >Hora:</span>
                                    </td>

                                    <td style="border-right:solid #a80077 1px;text-align:left">
                                        <span id="fecha" ><%=sdfHora.format(fechaCierre)%></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="" style="border-left:solid #a80077 1px;text-align:left">
                                        <span >Observacion</span>
                                    </td>

                                    <td class="" style="border-right:solid #a80077 1px;text-align:left">
                                        <input type="text" id="observacion" value="<%=(observaciones)%>"/>
                                    </td>
                                </tr>
                            </table>
                            <%
                                }
                            %>
                        </center>


                        <%
                                out.println("<div class='row' style='margin-top:0px;'>");
                                out.println("<div class='large-6 small-8 medium-10 large-centered medium-centered columns'>");
                                out.println("<div class='row'>");
                                if (codTipoPermiso == 12) {
                                    out.println("<div class='large-4 medium-6 small-12 columns'>");
                                    out.println("<button class='small button succes radius buttonAction' onclick='guardarAcondicionamientoAmpollas(false,2);' >Aprobar</button>");
                                    out.println("</div>");
                                    out.println("<div class='large-4 medium-6 small-12 columns'>");
                                    out.println("<button class='small button succes radius buttonAction' onclick='guardarAcondicionamientoAmpollas(false,1);' >Pre Aprobar</button>");
                                    out.println("</div>");
                                    out.println("<div class='large-4 medium-6 small-12  columns'>");
                                    out.println("<button class='small button succes radius buttonAction' onclick='window.close();' >Cancelar</button>");
                                    out.println("</div>");
                                } else {
                                    out.println("<div class='large-6 medium-6 small-12 columns'>");
                                    out.println("<button class='small button succes radius buttonAction' onclick='guardarAcondicionamientoAmpollas(false,0);' >Guardar</button>");
                                    out.println("</div>");
                                    out.println("<div class='large-6 medium-6 small-12  columns'>");
                                    out.println("<button class='small button succes radius buttonAction' onclick='window.close();' >Cancelar</button>");
                                    out.println("</div>");
                                }
                                out.println("</div>");
                                out.println("</div>");
                                out.println("</div>");

                            } catch (SQLException ex) {
                                ex.printStackTrace();
                            }
                        %>


                    </div>
                </div>
            </div>
        </div>
        <div  id="formsuper" class="formSuper" />
        <input type="hidden" id="codActividadAcond" value="<%=(codActividadAcond)%>"/>
        <input type="hidden" id="codActividadEmbalado" value="<%=(codActividadEmbalado)%>"/>

    </section>
</body>
<script src="../../reponse/js/timePickerJs.js"></script>
<script src="../../reponse/js/dataPickerJs.js"></script>
<script src="../../reponse/js/mensajejs.js"></script>
<script>iniciarDatePicker('<%=(sdfDias.format(new Date()))%>');
    loginHoja.verificarHojaCerradaAcond("cerrado", administradorSistema, 5, <%=(codEstadoHoja)%>); 
</script>
</html>
