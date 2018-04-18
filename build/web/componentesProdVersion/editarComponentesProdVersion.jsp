<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<html>
    <head>
        <title>SISTEMA</title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <link rel="STYLESHEET" type="text/css" href="../css/chosen.css" />
        <script type="text/javascript" src="../js/general.js"></script>
        <script type="text/javascript">

                    function focusRed(celda)
                    {
                        celda.focus();
                        celda.style.backgroundColor='rgb(255, 182, 193)';
                    }
                    function validarRegistro(controlRs,controlCp)
                    {
                        //validacion para regencia farmacetica
                        if(controlRs)
                        {
                            if(document.getElementById("form1:isProductoSemiterminado:1").checked)
                            {
                                
                                if(!validarRegistroNoVacioById("form1:unidadMedidadProducto"))
                                {
                                    return false;
                                }
                                var tabla=document.getElementById("form1:dataMaterialesConcentracion").getElementsByTagName("tbody")[0];
                                var concentracion="";
                                for(var i=0;i<tabla.rows.length;i++)
                                {
                                    
                                    var select=tabla.rows[i].cells[3].getElementsByTagName("select")[0];
                                    concentracion+=(concentracion==""?"":",")+tabla.rows[i].cells[0].getElementsByTagName("span")[0].innerHTML+
                                                    " "+tabla.rows[i].cells[2].getElementsByTagName("input")[0].value+" "+
                                                    (parseInt(select.value)>0?select.options[select.selectedIndex].innerHTML:"");
                                    var select2=tabla.rows[i].cells[6].getElementsByTagName("select")[0];
                                    concentracion+=(parseFloat(tabla.rows[i].cells[5].getElementsByTagName("input")[0].value)>0?
                                                    " equivalente a "+tabla.rows[i].cells[4].getElementsByTagName("input")[0].value+" "+
                                                    tabla.rows[i].cells[5].getElementsByTagName("input")[0].value+" "+
                                                    (parseInt(select2.value)>0?select2.options[select.selectedIndex].innerHTML:""):"");
                                    
                                }
                                if(concentracion=='')
                                {
                                     alert('Debe registrar los materiales de la concentracion');
                                     return false;
                                }
                            }       
                        }
                        return true;
                    }

                    function visibilityPanel(){
                        document.getElementById('form1:panelBuscar').style.visibility='hidden';
                    }
                    function formarNombre(){

                        var nombreProducto=document.getElementById('form1:producto');
                        var nombreProductoSem=nombreProducto.options[nombreProducto.selectedIndex].text;
                        var productosFormasFar=document.getElementById('form1:productosFormasFar');
                        var nombreProductoSem1=productosFormasFar.options[productosFormasFar.selectedIndex].text;
                        //var cantidadPeso=document.getElementById('form1:volumenPesoPresentacion');
                        //alert(cantidadPeso.value);
                        var nombreProductoSemiterminado=document.getElementById('form1:nombreProductoSemiterminado');
                        nombreProductoSemiterminado.value=nombreProductoSem+" "+nombreProductoSem1;//+" "+cantidadPeso.value;

                    }
                    function generarConcentracion()
                    {
                        var tabla=document.getElementById("form1:dataMaterialesConcentracion").getElementsByTagName("tbody")[0];
                        var concentracion="";
                        for(var i=0 ; i<tabla.rows.length ; i++)
                        {
                            if(!tabla.rows[i].cells[7].getElementsByTagName("input")[0].checked)
                            {
                                var select=tabla.rows[i].cells[3].getElementsByTagName("select")[0];
                                concentracion+=(concentracion==""?"":",")+tabla.rows[i].cells[0].getElementsByTagName("span")[0].innerHTML+
                                                " "+tabla.rows[i].cells[2].getElementsByTagName("input")[0].value+" "+
                                                (parseInt(select.value)>0?select.options[select.selectedIndex].innerHTML:"");
                                var select2=tabla.rows[i].cells[6].getElementsByTagName("select")[0];
                                concentracion+=(parseFloat(tabla.rows[i].cells[5].getElementsByTagName("input")[0].value)>0?
                                                " equivalente a "+tabla.rows[i].cells[4].getElementsByTagName("input")[0].value+" "+
                                                tabla.rows[i].cells[5].getElementsByTagName("input")[0].value+" "+
                                                (parseInt(select2.value)>0?select2.options[select2.selectedIndex].innerHTML:""):"");
                            }

                        }
                        document.getElementById("form1:concentracionProducto").innerHTML=concentracion+"/"+document.getElementById("form1:dataMaterialesConcentracion:unidadMedidadProducto").value;
                    }
                    function validarFecha(celda)
                    {
                        if(celda.value!='')
                        {
                            if(!valFecha(celda))
                            {
                                celda.focus();
                                celda.style.backgroundColor='rgb(255, 182, 193)';
                            }
                        }
                    }
                    function mostrarOcultarConcentracion()
                    {
                        document.getElementById("tablaConcentracion").style.display=(document.getElementById("form1:isProductoSemiterminado:1").checked?'':'none');
                    }
                    function retornarNavegadorVersion(codTipoModificacionProducto)
                    {
                        var url="";
                        switch(codTipoModificacionProducto)
                        {
                            case 1:
                            {
                                url="navegadorNuevosComponentesProd";
                                break;
                            }
                            case 2:
                            {
                                url="navegadorNuevosTamaniosLote";
                                break;
                            }
                            case 3:
                            {
                                url="navegadorComponentesProdVersion";
                                break;
                            }
                            case 4:
                            {
                                url="navegadorNuevosComponentesProd";
                                break;
                            }
                        }
                        window.location.href=url+".jsf?date="+(new Date()).getTime().toString();
                    }
    </script>
    <style type="text/css">
        .multiple{
            color:white;
            background-color:#aaaaaa;
            font-weight:bold;
            font-size:14px;
        }
    </style>
</head>
<body >
    <f:view>
    <a4j:form id="form1"  >
        <center>
            <h:outputText value="#{ManagedComponentesProdVersion.cargarEdicionComponentesProdVersion_action}"/>
            <rich:panel headerClass="headerClassACliente" style="width:80%" id="contenidoEditar">
                <f:facet name="header">
                    <h:outputText value="Edición de Producto"/>
                </f:facet>
                <h:panelGrid columns="3" rendered="#{ManagedComponentesProdVersion.componentesProdVersionEditar.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 33}" id="panelEditar">
                    <h:outputText value="Nro. Versión" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.nroVersion}" styleClass="outputText2"/>
                    <h:outputText value="Producto Semi-Elaborado" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectOneRadio value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.productoSemiterminado}" styleClass="outputText2"
                        id="isProductoSemiterminado">
                        <f:selectItem itemValue='true' itemLabel="SI"/>
                        <f:selectItem itemValue='false' itemLabel="NO"/>
                        <a4j:support event="onclick" reRender="contenidoEditar"/>
                    </h:selectOneRadio>

                    <h:outputText value="Nombre Comercial" styleClass="outputTextBold" rendered="#{!ManagedComponentesProdVersion.componentesProdVersionEditar.productoSemiterminado}"/>
                    <h:outputText value="::" styleClass="outputTextBold" rendered="#{!ManagedComponentesProdVersion.componentesProdVersionEditar.productoSemiterminado}"/>
                    <h:panelGroup rendered="#{!ManagedComponentesProdVersion.componentesProdVersionEditar.productoSemiterminado}"
                                  id="contenidoNombreComercial">
                        <h:selectOneMenu value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.producto.codProducto}"
                                         styleClass="inputText chosen">
                            <f:selectItems value="#{ManagedComponentesProdVersion.productosSelectList}"/>
                        </h:selectOneMenu>
                        <a4j:commandButton value="Agregar Nuevo" styleClass="btn"
                                           action="#{ManagedComponentesProdVersion.agregarNuevoProductoAction}"
                                           reRender="contenidoCrearNuevoProducto"
                                           oncomplete="Richfaces.showModalPanel('panelCrearNuevoProducto')"/>
                    </h:panelGroup>

                    <h:outputText value="Forma Farmaceútica" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectOneMenu value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.forma.codForma}" styleClass="inputText chosen">
                        <f:selectItems value="#{ManagedComponentesProdVersion.formasFarmaceuticasSelectList}"/>
                    </h:selectOneMenu>
                    <h:outputText value="Sabor" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectOneMenu value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.saboresProductos.codSabor}" styleClass="inputText chosen">
                        <f:selectItem itemLabel="--Ninguno--" itemValue="0"/>
                        <f:selectItems value="#{ManagedComponentesProdVersion.saboresProductoSelectList}"/>
                    </h:selectOneMenu>
                    <h:outputText value="Condición de Venta" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectOneMenu value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.condicionesVentasProducto.codCondicionVentaProducto}" styleClass="inputText">
                        <f:selectItem itemValue='0' itemLabel="--No Aplica--"/>
                        <f:selectItems value="#{ManagedComponentesProdVersion.condicionesVentasSelectList}"/>
                    </h:selectOneMenu>
                    <h:outputText value="Presentaciones Registradas" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:inputTextarea value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.presentacionesRegistradasRs}" styleClass="inputText" style="width:100%" cols="4"/>
                    <h:outputText value="Registro Sanitario" styleClass="outputTextBold" rendered="#{!ManagedComponentesProdVersion.componentesProdVersionEditar.productoSemiterminado}"/>
                    <h:outputText value="::" styleClass="outputTextBold" rendered="#{!ManagedComponentesProdVersion.componentesProdVersionEditar.productoSemiterminado}"/>
                    <h:panelGroup rendered="#{!ManagedComponentesProdVersion.componentesProdVersionEditar.productoSemiterminado}">
                        <h:inputText value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.regSanitario}" 
                                     styleClass="inputText" style="width:100%" id="regSanitario" 
                                     required="#{(not empty param['form1:btnGuardar'])}"
                                     requiredMessage="El registro sanitario no puede estar vacio" />
                        <h:message for="regSanitario" styleClass="message"/>
                    </h:panelGroup>
                    <h:outputText value="Fecha Vencimiento" styleClass="outputTextBold" rendered="#{!ManagedComponentesProdVersion.componentesProdVersionEditar.productoSemiterminado}"/>
                    <h:outputText value="::" styleClass="outputTextBold" rendered="#{!ManagedComponentesProdVersion.componentesProdVersionEditar.productoSemiterminado}"/>
                    <h:panelGroup rendered="#{!ManagedComponentesProdVersion.componentesProdVersionEditar.productoSemiterminado}">
                        <rich:calendar value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.fechaVencimientoRS}" styleClass="inputText"
                                       datePattern="dd/MM/yyyy" id="fechaVencimientoRs" 
                                       required="#{(not empty param['form1:btnGuardar'])}"
                                       requiredMessage="La fecha de vencimiento no puede estar vacia">
                        </rich:calendar>
                        <h:message for="fechaVencimientoRs" styleClass="message"/>
                    </h:panelGroup>
                    <h:outputText value="Vida Util" styleClass="outputTextBold" id="vidadUtil" rendered="#{!ManagedComponentesProdVersion.componentesProdVersionEditar.productoSemiterminado}"/>
                    <h:outputText value="::" styleClass="outputTextBold" rendered="#{!ManagedComponentesProdVersion.componentesProdVersionEditar.productoSemiterminado}"/>
                    <h:panelGroup rendered="#{!ManagedComponentesProdVersion.componentesProdVersionEditar.productoSemiterminado}">
                        <h:inputText value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.vidaUtil}"
                                     required="true"
                                     requiredMessage="Debe registrar la vida util del producto"
                                     converterMessage="Debe registrar un dato entero"
                                     styleClass="inputText" style="width:8em" id="vidaUtil" onkeypress="valNum(event);">
                            <f:validator validatorId="validatorDoubleRange"/>
                            <f:attribute name="minimum" value="12"/>
                            <f:attribute name="disable" value="#{(empty param['form1:btnGuardar'])}"/>
                        </h:inputText>
                        <h:outputText value="(meses)" styleClass="outputTextBold"/>
                        <h:message for="vidaUtil" styleClass="message"/>
                    </h:panelGroup>
                    
                    <h:outputText value="Nombre Genérico/Concentración" styleClass="outputTextBold" rendered="#{!ManagedComponentesProdVersion.componentesProdVersionEditar.productoSemiterminado}"/>
                    <h:outputText value="::" styleClass="outputTextBold" rendered="#{!ManagedComponentesProdVersion.componentesProdVersionEditar.productoSemiterminado}"/>
                    <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.concentracionEnvasePrimario}" id="concentracionProducto" styleClass="outputText2" rendered="#{!ManagedComponentesProdVersion.componentesProdVersionEditar.productoSemiterminado}"/>
                </h:panelGrid>
                    <h:panelGrid columns="3" rendered="#{ManagedComponentesProdVersion.controlNuevoProducto || ManagedComponentesProdVersion.componentesProdVersionEditar.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 34}" id="panelDT">
                        <h:outputText value="Nro. Versión" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.nroVersion}" styleClass="outputText2"/>
                        <h:outputText value="Nombre Producto" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:panelGroup>
                            <h:inputText value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.nombreProdSemiterminado}" 
                                         styleClass="inputText" style="width:25em" 
                                         required="#{(not empty param['form1:btnGuardar'])}"
                                         requiredMessage="Debe registrar el nombre del producto"
                                         id="nombreProdSemiterminado"/>
                            <h:message for="nombreProdSemiterminado" styleClass="message"/>
                        </h:panelGroup>
                        <h:outputText value="Area de fabricación" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:selectOneMenu value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa}" styleClass="inputText">
                            <f:selectItems value="#{ManagedComponentesProdVersion.areasEmpresaSelectList}"/>
                            <a4j:support event="onchange" reRender="panelDT"/>
                        </h:selectOneMenu>
                        <h:outputText value="Via Administración" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:selectOneMenu value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.viasAdministracionProducto.codViaAdministracionProducto}" styleClass="inputText">
                            <f:selectItems value="#{ManagedComponentesProdVersion.viasAdministracionSelectList}"/>
                        </h:selectOneMenu>
                        <h:outputText value="Unidad Medida Volumen" styleClass="outputTextBold" rendered="#{ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '80'||ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '81'}"/>
                        <h:outputText value="::" styleClass="outputTextBold" rendered="#{ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '80'||ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '81'}"/>
                        <h:selectOneMenu style="margin-left:0.2em" value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.unidadMedidaVolumen.codUnidadMedida}" styleClass="inputText" rendered="#{ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '80'||ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '81'}">
                            <f:selectItems value="#{ManagedComponentesProdVersion.unidadesMedidaSelectList}"/>
                        </h:selectOneMenu>
                        <h:outputText value="Volumen envase primario" styleClass="outputTextBold" rendered="#{ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '80'||ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '81'}"/>
                        <h:outputText value="::" styleClass="outputTextBold" rendered="#{ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '80'||ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '81'}"/>
                        <h:panelGroup rendered="#{ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '80'||ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '81'}">
                            <h:inputText size="20" value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.cantidadVolumen}"
                                         styleClass="inputText" id="cantidadVolumen" onkeypress="valNum();" 
                                         required="#{(not empty param['form1:btnGuardar'])}"
                                         converterMessage="Debe registrar un numero">
                                <f:validator validatorId="validatorDoubleRange"/>
                                <f:attribute name="minimum" value="0.1"/>
                                <f:attribute name="disable" value="#{(empty param['form1:btnGuardar'])}"/>
                            </h:inputText>
                            <h:message for="cantidadVolumen" styleClass="message"/>
                        </h:panelGroup>
                        <h:outputText value="Volumen de dosificado" styleClass="outputTextBold" rendered="#{ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '81'}"/>
                        <h:outputText value="::" styleClass="outputTextBold" rendered="#{ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '81'}"/>
                        <h:panelGroup rendered="#{ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '81'}">
                            <h:inputText size="10" required="#{(not empty param['form1:btnGuardar'])}"
                                         requiredMessage="Debe registrar el volument de dosicado"
                                         converterMessage="Debe registrar un numero"
                                         value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.cantidadVolumenDeDosificado}" 
                                         styleClass="inputText" id="cantidadVolumenDosificado" onkeypress="valNum();">
                                <f:validator validatorId="validatorDoubleRange"/>
                                <f:attribute name="minimum" value="0.1"/>
                                <f:attribute name="disable" value="#{(empty param['form1:btnGuardar'])}"/>
                            </h:inputText>
                            <h:message for="cantidadVolumenDosificado" styleClass="message"/>
                        </h:panelGroup>

                        <h:outputText value="Tolerancia a Fabricar" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:panelGroup>
                            <h:inputText value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.toleranciaVolumenfabricar}" onkeypress="valNum();" styleClass="inputText" style="width:5em"/>
                            <h:outputText value="(%)" styleClass="outputTextBold"/>
                        </h:panelGroup>
                        <h:outputText value="Peso Teórico del Producto" styleClass="outputTextBold" rendered="#{ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '95'||ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '82'}"/>
                        <h:outputText value="::" styleClass="outputTextBold" rendered="#{ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '95'||ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '82'}"/>
                        <h:panelGrid columns="2" rendered="#{ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '95'||ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '82'}">
                            <h:panelGroup>
                                <h:inputText value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.pesoTeorico}"
                                             id="cantidadpesoTeorico" requiredMessage="Debe registrar el peso del producto"
                                             styleClass="inputText"
                                             required="#{(not empty param['form1:btnGuardar'])}"
                                             converterMessage="Debe registrar un numero">
                                    <f:validator validatorId="validatorDoubleRange"/>
                                    <f:attribute name="minimum" value="0.1"/>
                                    <f:attribute name="disable" value="#{(empty param['form1:btnGuardar'])}"/>
                                </h:inputText>
                                <h:message for="cantidadpesoTeorico" styleClass="message"/>
                            </h:panelGroup>
                            <h:selectOneMenu style="margin-left:0.2em"
                                             value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.unidadMedidaPesoTeorico.codUnidadMedida}" 
                                             styleClass="inputText">
                                <f:selectItems value="#{ManagedComponentesProdVersion.unidadesMedidaSelectList}"/>
                            </h:selectOneMenu>

                        </h:panelGrid>
                        <h:outputText value="Limite de Alerta(%)" styleClass="outputTextBold" rendered="#{ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '95'||ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '82'}"/>
                        <h:outputText value="::" styleClass="outputTextBold" rendered="#{ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '95'||ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '82'}"/>
                        <h:panelGroup rendered="#{ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '95'||ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '82'}">
                            <h:inputText value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.porcientoLimiteAlerta}"
                                        id="limiteAlerta" requiredMessage="Debe registrar el limite de alerta"
                                        styleClass="inputText"
                                        required="#{(not empty param['form1:btnGuardar'])}"
                                        converterMessage="Debe registrar un numero">
                                <f:validator validatorId="validatorDoubleRange"/>
                                <f:attribute name="minimum" value="0.1"/>
                                <f:attribute name="disable" value="#{(empty param['form1:btnGuardar'])}"/>
                            </h:inputText>
                            <h:message for="limiteAlerta" styleClass="message"/>
                        </h:panelGroup>
                        <h:outputText value="Limite de Acción(%)" styleClass="outputTextBold" rendered="#{ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '95'||ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '82'}"/>
                        <h:outputText value="::" styleClass="outputTextBold" rendered="#{ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '95'||ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '82'}"/>
                        <h:panelGroup rendered="#{ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '95'||ManagedComponentesProdVersion.componentesProdVersionEditar.areasEmpresa.codAreaEmpresa eq '82'}">
                            <h:inputText value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.porcientoLimiteAccion}"
                                        id="limiteAccion" requiredMessage="Debe registrar el limite de acción"
                                        styleClass="inputText"
                                        required="#{(not empty param['form1:btnGuardar'])}"
                                        converterMessage="Debe registrar un numero">
                                <f:validator validatorId="validatorDoubleRange"/>
                                <f:attribute name="minimum" value="0.1"/>
                                <f:attribute name="disable" value="#{(empty param['form1:btnGuardar'])}"/>
                            </h:inputText>
                            <h:message for="limiteAccion" styleClass="message"/>
                        </h:panelGroup>
                        <h:outputText value="Color Presentación Primaria" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:selectOneMenu value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.coloresPresentacion.codColor}" 
                                         styleClass="inputText">
                            <f:selectItem itemLabel="--Ninguno--" itemValue="0" />
                            <f:selectItems value="#{ManagedComponentesProdVersion.coloresPresPrimSelectList}"/>
                        </h:selectOneMenu>
                        <h:outputText value="Tamaño Capsula" styleClass="outputTextBold" rendered="#{ManagedComponentesProdVersion.componentesProdVersionEditar.forma.codForma eq '6'}"/>
                        <h:outputText value="::" styleClass="outputTextBold" rendered="#{ManagedComponentesProdVersion.componentesProdVersionEditar.forma.codForma eq '6'}"/>
                        <h:selectOneMenu value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.tamaniosCapsulasProduccion.codTamanioCapsulaProduccion}" styleClass="inputText"
                        rendered="#{ManagedComponentesProdVersion.componentesProdVersionEditar.forma.codForma eq '6'}">
                            <f:selectItem itemValue='0' itemLabel="--Ninguno--"/>
                            <f:selectItems value="#{ManagedComponentesProdVersion.tamaniosCapsulasSelectList}"/>
                        </h:selectOneMenu>
                        <h:outputText value="Tamaño Lote" styleClass="outputTextBold" />
                        <h:outputText value="::" styleClass="outputTextBold" />
                        <h:panelGroup>
                            <h:inputText value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.tamanioLoteProduccion}" 
                                         required="#{(not empty param['form1:btnGuardar'])}" converterMessage="Debe registrar un numero entero" 
                                         id="cantidadLote"
                                         onkeypress="valNum();" styleClass="inputText">
                                <f:validator validatorId="validatorDoubleRange"/>
                                <f:attribute name="minimum" value="1"/>
                                <f:attribute name="disable" value="#{(empty param['form1:btnGuardar'])}"/>
                            </h:inputText>
                            <h:message for="cantidadLote" styleClass="message"/>
                        </h:panelGroup>
                        <h:outputText value="Estado" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:selectOneMenu value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.estadoCompProd.codEstadoCompProd}" styleClass="inputText">
                            <f:selectItem itemValue="1" itemLabel="Activo"/>
                            <f:selectItem itemValue="2" itemLabel="Discontinuado"/>
                        </h:selectOneMenu>
                        <h:outputText value="Aplica Especificaciones Físicas" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:selectBooleanCheckbox value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.aplicaEspecificacionesFisicas}"/>
                        <h:outputText value="Aplica Especificaciones Químicas" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:selectBooleanCheckbox value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.aplicaEspecificacionesQuimicas}"/>
                        <h:outputText value="Aplica Especificaciones Microbiologicas" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:selectBooleanCheckbox value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.aplicaEspecificacionesMicrobiologicas}"/>
                        <h:outputText value="Información Completa del producto?" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:selectBooleanCheckbox value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.informacionCompleta}"
                                                 rendered="#{!ManagedComponentesProdVersion.componentesProdBean.informacionCompleta}"/>
                        <h:outputText value="El producto ya fue definido como completo"
                                      styleClass="outputTextBold" style="color:red"
                                      rendered="#{ManagedComponentesProdVersion.componentesProdBean.informacionCompleta}"/>
                    </h:panelGrid>
                    
                    <rich:dataTable value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.componentesProdConcentracionList}" var="data" id="dataMaterialesConcentracion"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    rowKeyVar="index"
                                    rendered="#{ManagedComponentesProdVersion.componentesProdVersionEditar.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 33
                                                and (!ManagedComponentesProdVersion.componentesProdVersionEditar.productoSemiterminado)}"
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                    headerClass="headerClassACliente" columnClasses="tituloCampo">
                            <f:facet name="header">
                                <rich:columnGroup>
                                    <rich:column colspan="9">
                                        <h:outputText value="Concentracion para :  "/>
                                        <h:inputText value="#{ManagedComponentesProdVersion.componentesProdConcentracionBean.unidadProducto}" rendered="#{ManagedComponentesProdVersion.controlRegistroSanitario}" styleClass="inputText" 
                                                     required="#{(not empty param['form1:btnGuardar'])}"
                                                     requiredMessage="El dato no puede estar vacio"
                                                     id="unidadMedidadProducto" onkeyup="generarConcentracion();"/>
                                        <h:message for="unidadMedidadProducto" styleClass="message"/>
                                    </rich:column>
                                    <rich:column breakBefore="true">
                                        <h:outputText value="Nombre Genérico"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Nombre Material"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Cantidad"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Unidad Medida"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Material Equivalencia"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Cantidad Equivalente"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Unidad Medida"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Excipiente"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Eliminar"/>
                                    </rich:column>
                                </rich:columnGroup>
                            </f:facet>
                                 <rich:column>
                                     <h:outputText value="#{data.materiales.nombreCCC}" styleClass="outputText2"/>
                                 </rich:column>
                                 <rich:column >
                                     <h:outputText value="#{data.materiales.nombreMaterial}" styleClass="outputText2"/>
                                 </rich:column >
                                 <rich:column >
                                     <h:inputText value="#{data.cantidad}" size="6"  id="cantidadMaterialConcentracion"
                                                  onkeypress="valNum(event);" onkeyup="generarConcentracion()" styleClass="inputText">
                                        <f:validator validatorId="validatorDoubleRange"/>
                                        <f:attribute name="minimum" value="0.01"/>
                                        <f:attribute name="disable" value="#{(empty param['form1:btnGuardar'])}"/>
                                     </h:inputText>
                                     <h:message for="cantidadMaterialConcentracion" styleClass="message"/>
                                 </rich:column >
                                 <rich:column >
                                     <h:selectOneMenu  onchange="generarConcentracion()" value="#{data.unidadesMedida.codUnidadMedida}" styleClass="inputText">
                                         <f:selectItems value="#{ManagedComponentesProdVersion.unidadesMedidaSelectList}"/>
                                     </h:selectOneMenu>
                                 </rich:column >
                                 <rich:column>
                                     <h:inputText value="#{data.nombreMaterialEquivalencia}" styleClass="inputText" onkeyup="generarConcentracion();"/>
                                 </rich:column>
                                 <rich:column>
                                     <h:inputText size="6" value="#{data.cantidadEquivalencia}" onkeypress="valNum(event)" onblur="valorPorDefecto(this);validarMayorIgualACero(this);" onkeyup="generarConcentracion();" styleClass="inputText"/>
                                 </rich:column>
                                 <rich:column>
                                     <h:selectOneMenu  onchange="generarConcentracion()" value="#{data.unidadMedidaEquivalencia.codUnidadMedida}" styleClass="inputText">
                                         <f:selectItems value="#{ManagedComponentesProdVersion.unidadesMedidaSelectList}"/>
                                     </h:selectOneMenu>
                                 </rich:column>
                                 <rich:column>
                                     <h:selectBooleanCheckbox value="#{data.excipiente}" onclick="generarConcentracion()"/>
                                 </rich:column>
                                <rich:column>
                                    <a4j:commandButton value="Eliminar" styleClass="btn"
                                                    reRender="dataMaterialesConcentracion"
                                                    actionListener="#{ManagedComponentesProdVersion.componentesProdVersionEditar.componentesProdConcentracionList.remove(data)}"/>
                                </rich:column>
                                 <f:facet name="footer">
                                     <rich:columnGroup>
                                         <rich:column colspan="9" styleClass="tdCenter">
                                            <a4j:commandButton value="Agregar Material" styleClass="btn"
                                                    reRender="contenidoAgregarMaterialConcentracion"
                                                    oncomplete="Richfaces.showModalPanel('panelAgregarMaterialConcentracion')"/>
                                        </rich:column>
                                     </rich:columnGroup>
                                 </f:facet> 
                         </rich:dataTable>
                        <h:inputHidden value="#{ManagedComponentesProdVersion.componentesProdVersionEditar.concentracionEnvasePrimario}" id="concentracionInput"/>
                        <a4j:commandButton id="btnGuardar" 
                                       reRender="contenidoEditar" value="Guardar" 
                                       onclick="if(!validarRegistro(#{ManagedComponentesProdVersion.controlRegistroSanitario},#{ManagedComponentesProdVersion.controlPresentacionPrimaria})){return false;}"
                                       action="#{ManagedComponentesProdVersion.guardarEdicionComponentesProdVersion_action}" styleClass="btn"
                                       oncomplete="if('#{facesContext.maximumSeverity}'.length == 0){
                                                    mostrarMensajeTransaccionEvento(function(){retornarNavegadorVersion(#{ManagedComponentesProdVersion.componentesProdVersionEditar.tiposModificacionProducto.codTipoModificacionProducto});})}"/>
                        <a4j:commandButton value="Cancelar" oncomplete="retornarNavegadorVersion(#{ManagedComponentesProdVersion.componentesProdVersionEditar.tiposModificacionProducto.codTipoModificacionProducto});" styleClass="btn"/>
                </rich:panel>
        </center>
        
    </a4j:form>
    <rich:modalPanel id="panelAgregarMaterialConcentracion"  minHeight="173"  minWidth="420"
                        height="350" width="550"
                        zindex="50"
                        headerClass="headerClassACliente"
                        resizeable="false" style="overflow :auto" >
        <f:facet name="header">
            <h:outputText value="<center>Agregar Material a concentración</center>" escape="false"/>
        </f:facet>
        <a4j:form>
            <center>
           <h:panelGroup id="contenidoAgregarMaterialConcentracion">
               <rich:panel headerClass="headerClassACliente">
                   <f:facet name="header">
                       <h:outputText value="Buscador"/>
                   </f:facet>
                    <h:panelGrid columns="6" style="width:100%">
                         <h:outputText value="Nombre Material" styleClass="outputTextBold"/>
                         <h:outputText value="::" styleClass="outputTextBold"/>
                         <h:panelGroup>
                             <h:inputText value="#{ManagedComponentesProdVersion.materialesBuscar.nombreMaterial}" styleClass="inputText"/>
                         </h:panelGroup>
                         <h:outputText value="Nombre Generico" styleClass="outputTextBold"/>
                         <h:outputText value="::" styleClass="outputTextBold"/>
                         <h:panelGroup>
                             <h:inputText value="#{ManagedComponentesProdVersion.materialesBuscar.nombreCCC}" styleClass="inputText"/>
                         </h:panelGroup>
                    </h:panelGrid>
                   <a4j:commandButton value="Buscar" action="#{ManagedComponentesProdVersion.buscarMaterialAction()}"
                                      styleClass="btn"
                                      reRender="dataMaterial"/>
                </rich:panel>
               <div style="width:100%;height:150px;overflow-y: auto">
                <rich:dataTable value="#{ManagedComponentesProdVersion.materialesList}"
                                id="dataMaterial" styleClass="margin-top:8px"
                                headerClass="headerClassACliente" var="material">
                    <f:facet name="header">
                        <rich:columnGroup>
                             <rich:column>
                                 <h:outputText value="Seleccionar"/>
                             </rich:column>
                             <rich:column>
                                 <h:outputText value="Nombre"/>
                             </rich:column>
                             <rich:column>
                                 <h:outputText value="Nombre Generico"/>
                             </rich:column>
                        </rich:columnGroup>
                    </f:facet>
                     <rich:column>
                         <a4j:commandButton value="Seleccionar" action="#{ManagedComponentesProdVersion.seleccionarAgregarMaterialConcentracionAction()}"
                                            reRender="dataMaterialesConcentracion" styleClass="btn" oncomplete="Richfaces.hideModalPanel('panelAgregarMaterialConcentracion');generarConcentracion();">
                             <f:setPropertyActionListener value="#{material}" target="#{ManagedComponentesProdVersion.materiales}"/>
                         </a4j:commandButton>
                     </rich:column>
                    <rich:column>
                         <h:outputText value="#{material.nombreMaterial}"/>
                     </rich:column>
                     <rich:column>
                         <h:outputText value="#{material.nombreCCC}"/>
                     </rich:column>
                </rich:dataTable>
               </div>
           </h:panelGroup>  
           <a4j:commandButton value="Cancelar" styleClass="btn"
                                oncomplete="Richfaces.hideModalPanel('panelAgregarMaterialConcentracion')"/>
            </center>
        </a4j:form>
    </rich:modalPanel>
    
    <rich:modalPanel id="panelCrearNuevoProducto"  minHeight="173"  minWidth="420"
                        height="150" width="450"
                        zindex="50"
                        headerClass="headerClassACliente"
                        resizeable="false" style="overflow :auto" >
        <f:facet name="header">
            <h:outputText value="<center>Crear Nombre Comercial</center>" escape="false"/>
        </f:facet>
        <a4j:form>
            <center>
           <h:panelGroup id="contenidoCrearNuevoProducto">
               <h:panelGrid columns="3" style="width:100%">
                    <h:outputText value="Nombre" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:panelGroup>
                        <h:inputText value="#{ManagedComponentesProdVersion.producto.nombreProducto}"
                                     style="width:100%" onkeyup="valInputMay(this)"
                                     id="nombreProducto"
                                     required="true"
                                     requiredMessage="Debe registrar el nombre"/>
                        <h:message styleClass="message" for="nombreProducto"/>
                    </h:panelGroup>
               </h:panelGrid>
           </h:panelGroup>
            <br/>
            <a4j:commandButton value="Guardar" oncomplete="if('#{facesContext.maximumSeverity}'.length == 0){Richfaces.hideModalPanel('panelCrearNuevoProducto');}"
                               reRender="contenidoCrearNuevoProducto,contenidoEditar"
                               action="#{ManagedComponentesProdVersion.guardarProducto()}"
                                styleClass="btn"/>
            <a4j:commandButton value="Cancelar" styleClass="btn"
                                oncomplete="Richfaces.hideModalPanel('panelCrearNuevoProducto')"/>
            </center>
        </a4j:form>
    </rich:modalPanel>
    <a4j:include viewId="/panelProgreso.jsp"/>
    <a4j:include viewId="/message.jsp"/>
    
    </f:view>
</body>
</html>





