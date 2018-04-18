<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script src="../../js/general.js" type="text/javascript"></script>
            <style>
                .negrita
                {
                    font-weight:bold;
                }
            </style>
            <script>
                function validarGuardar()
                {
                    if(document.getElementById("form1:cantidadPresentacion").value==''||isNaN(document.getElementById("form1:cantidadPresentacion").value)||
                    parseInt(document.getElementById("form1:cantidadPresentacion").value)==0)
                    {
                        alert("No se reconoce el numero introducido en la cantidad");
                        return false;
                    }
                    return true;
                }
            </script>
            
        </head>
        <body >

            <a4j:form id="form1"  >
                <center>
                    <h:outputText value="#{ManagedProductosDesarrollo.cargarAgregarPresentacionPrimaria}"/>

                        <h3>Agregar Presentacion Primaria</h3>
                    <rich:panel headerClass="headerClassACliente" style="width:80%">
                        <f:facet name="header">
                            <h:outputText value="DATOS DEL PRODUCTO"/>
                        </f:facet>
                    <h:panelGrid columns="6">
                        <h:outputText value="Nombre Producto" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="#{ManagedProductosDesarrollo.componentesProdPresPrim.nombreProdSemiterminado}" styleClass="outputText2" />
                        <h:outputText value="Nombre Generico" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="#{ManagedProductosDesarrollo.componentesProdPresPrim.nombreGenerico}" styleClass="outputText2" />
                        <h:outputText value="Nombre Comercial" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="#{ManagedProductosDesarrollo.componentesProdPresPrim.producto.nombreProducto}" styleClass="outputText2" />
                        <h:outputText value="Color Presentacion Primaria" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="#{ManagedProductosDesarrollo.componentesProdPresPrim.coloresPresentacion.nombreColor}" styleClass="outputText2" />
                        <h:outputText value="Sabor" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="#{ManagedProductosDesarrollo.componentesProdPresPrim.saboresProductos.nombreSabor}" styleClass="outputText2" />
                        <h:outputText value="Area Fabricación" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="#{ManagedProductosDesarrollo.componentesProdPresPrim.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2" />
                        <h:outputText value="Via Administración" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="#{ManagedProductosDesarrollo.componentesProdPresPrim.viasAdministracionProducto.nombreViaAdministracionProducto}" styleClass="outputText2" />
                        <h:outputText value="Forma" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="#{ManagedProductosDesarrollo.componentesProdPresPrim.forma.nombreForma}" styleClass="outputText2" />

                    </h:panelGrid>
                    </rich:panel>


                        <h:panelGrid columns="3" styleClass="panelgrid" headerClass="headerClassACliente" style="width:70%;border:1px solid #cccccc;margin-top:9px">
                            <f:facet name="header" >
                                <h:outputText value="Introduzca  Datos" styleClass="outputText2"    />
                            </f:facet>
                            <h:outputText value="Cantidad" styleClass="outputText2 negrita" />
                            <h:outputText  styleClass="outputText2 negrita"  value="::"/>
                            <h:inputText styleClass="inputText" size="50" value="#{ManagedProductosDesarrollo.presentacionesPrimariaNuevo.cantidad}" onkeypress="valNum()"  id="cantidadPresentacion" />
                            <h:outputText value="Envase" styleClass="outputText2 negrita" />
                            <h:outputText  styleClass="outputText2 negrita"  value="::"/>
                            <h:selectOneMenu styleClass="inputText" value="#{ManagedProductosDesarrollo.presentacionesPrimariaNuevo.envasesPrimarios.codEnvasePrim}" id="codEnvasePrimario" >
                                <f:selectItems value="#{ManagedProductosDesarrollo.envasesPrimariosSelectList}"  />
                            </h:selectOneMenu>
                            <h:outputText value="Tipo Programa" styleClass="outputText2 negrita" />
                            <h:outputText  styleClass="outputText2 negrita"  value="::"/>
                            <h:selectOneMenu styleClass="inputText" value="#{ManagedProductosDesarrollo.presentacionesPrimariaNuevo.tiposProgramaProduccion.codTipoProgramaProd}" id="tipoPrograma" >
                                <f:selectItems value="#{ManagedProductosDesarrollo.tiposProgramaProdSelectList}"  />
                            </h:selectOneMenu>
                            <h:outputText value="Estado" styleClass="outputText2 negrita" />
                            <h:outputText  styleClass="outputText2 negrita"  value="::"/>
                            <h:outputText value="Activo" styleClass="outputText2"/>
                        </h:panelGrid>
                         
                        <br>

                        <a4j:commandButton value="Guardar" onclick="if(!validarGuardar()){return false;}" styleClass="btn" action="#{ManagedProductosDesarrollo.guardarNuevaPresentacionPrimaria_action}"
                        oncomplete="if(#{ManagedProductosDesarrollo.mensaje eq '1'}){alert('Se registro la presentacion primaria');window.location.href='navegadorPresentacionesPrimarias.jsf?codA='+(new Date()).getTime().toString();}
                        else {alert('#{ManagedProductosDesarrollo.mensaje}')}"/>
                        <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="window.location.href='navegadorPresentacionesPrimarias.jsf?codAc='+(new Date()).getTime().toString();"/>
                </a4j:form>
                 <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
                    </a4j:status>

                    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../../img/load2.gif" />
                        </div>
                    </rich:modalPanel>
            </center>
            <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js" ></script>
        </body>
    </html>

</f:view>

