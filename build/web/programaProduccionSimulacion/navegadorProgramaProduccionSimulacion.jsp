
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>

<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>

<html>
<head>
    <title>SISTEMA</title>
    <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
    <script type="text/javascript" src="../js/general.js" ></script> 
    <script>
                function cogerId(obj){
                    alert(obj);
                   
                  
                }
                function getCodigo(codigo,codFormula,cantidad, codProd,codLoteProd,codTipoProgramaProd){
                  //  alert(codLoteProd);
                  izquierda = (screen.width) ? (screen.width-300)/2 : 100 
                  arriba = (screen.height) ? (screen.height-400)/2 : 200 		
                  //url='../configuracionReporte/navegadorConfiguracionReporteReplica.jsf?codigo='+cod+'';			
                  url='detalle_navegador_programa_prod.jsf?codigo='+codigo+'&codFormula='+codFormula+'&cantidad='+cantidad+'&codCompProd='+codProd+'&cod_lote_prod='+codLoteProd+'&codTipoProgramaProd='+codTipoProgramaProd;
                  //alert(url);
                  opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=700,height=400,left='+izquierda+ ',top=' + arriba + ''
                  window.open(url, 'popUp',opciones)

                }
                function getCodigoReserva(codigo){
                
                  		
                  location='../reporteExplosionProductosSimulacion/guardarReservaProgramaProd.jsf?codigo='+codigo;


                }

                function editarItem(nametable){
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }
                         
                     }
                      
                   }
                   if(count==1){
                      return true;
                   } else if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   else if(count>1){
                       alert('Solo puede escoger un registro');
                       return false;
                   }                                      
                }


                function asignar(nametable){

                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    //alert('hola');
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }                         
                     }                      
                   }
                    if(count==0){
                       alert('No selecciono ningun Registro');
                       return false;
                   }else{
                       if(confirm('Desea Asignar como Area Raiz')){
                            if(confirm('Esta seguro de Asignar como Area Raiz')){
                                 return true;
                        }else{
                            return false;
                        }
                    }else{
                        return false;
                    }
                   
                   }
                   
                }    
                
            function eliminar(nametable){
               var count1=0;
               var elements1=document.getElementById(nametable);
               var rowsElement1=elements1.rows;
               //alert(rowsElement1.length);            
               for(var i=1;i<rowsElement1.length;i++){
                    var cellsElement1=rowsElement1[i].cells;
                    var cel1=cellsElement1[0];
                    if(cel1.getElementsByTagName('input').length>0){
                        if(cel1.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel1.getElementsByTagName('input')[0].checked){
                               count1++;
                           }
                        }
                    }
                    
               }
               //alert(count1);
               if(count1==0){
                    alert('No escogio ningun registro');
                    return false;
               }else{
                
                
                    if(confirm('Desea Eliminar el Registro')){
                        if(confirm('Esta seguro de Eliminar el Registro')){
                            var count=0;
                            var elements=document.getElementById(nametable);
                            var rowsElement=elements.rows;
                            
                            for(var i=0;i<rowsElement.length;i++){
                                var cellsElement=rowsElement[i].cells;
                                var cel=cellsElement[0];
                                if(cel.getElementsByTagName('input').length>0){
                                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                        if(cel.getElementsByTagName('input')[0].checked){
                                            count++;
                                        }
                                    }
                                }

                            }
                            if(count==0){
                            //alert('No escogio ningun registro');
                            return false;
                            }
                            //var cantidadeliminar=document.getElementById('form1:cantidadeliminar');
                            //cantidadeliminar.value=count;
                            return true;
                        }else{
                            return false;
                        }
                    }else{
                        return false;
                    }
                }
           }
    function nuevoAjax()
    {	var xmlhttp=false;
                try {
                        xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
                    } catch (e) {
                    try {
 			xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch (E) {
                        	xmlhttp = false;
                    }                    
                    }
                    if (!xmlhttp && typeof XMLHttpRequest!="undefined") {
                       xmlhttp = new XMLHttpRequest();
                    }
                    return xmlhttp;
     }
     function enviar(codProgramaProduccion)
     {
        document.getElementById('contenidoExplosion').style.visibility='visible';
        document.getElementById('contenidoExplosion').style.zIndex = 5;
        document.getElementById('contenidoExplosion').style.backgroundColor="#f2f2f2";
        document.getElementById('botonesExplosion').style.visibility='hidden';
        var ajax=nuevoAjax();
        var tablaLotes=document.getElementById("form1:dataFormula");
        var selectAlmacen=document.getElementById("formProcesos:codAlmacen");
        var arrayLote=new Array();
        var codigos=new Array();
        var codAlmacen=new Array();
        var nombreAlmacen=new Array();
        for(var i=0;i<selectAlmacen.options.length;i++)
        {
            if(selectAlmacen.options[i].selected)
            {
                codAlmacen.push(selectAlmacen.options[i].value);
                nombreAlmacen.push(selectAlmacen.options[i].innerHTML);
            }
        }
         for(var i=1;i<tablaLotes.rows.length;i++)
        {
            if(tablaLotes.rows[i].cells[0].getElementsByTagName("input")[0].checked)
            {
                arrayLote[arrayLote.length]="'"+tablaLotes.rows[i].cells[3].innerHTML+"$"+tablaLotes.rows[i].cells[7].getElementsByTagName("input")[0].value+"'";
                codigos.push(tablaLotes.rows[i].cells[1].getElementsByTagName("input")[0].value);
            }
        }
        if(codAlmacen.length==0)
        {
            alert("Debe Selecccionar por lo menos un almacen");
            return false;
        }
        var valores="codProgramaProduccion="+codProgramaProduccion+"&codigos="+codigos+"&conProductosEnProceso="+(document.getElementById("formProcesos:conProductosEnProceso").checked?1:0)+
                    "&lotes="+arrayLote+"&codAlmacen="+codAlmacen+"&nombreAlmacen="+nombreAlmacen;
        var url='explosionMaterialesProgramaProduccionSimulacion.jsf?date='+(new Date()).getTime().toString();
        
        
        ajax.open ('POST', url, true);
        ajax.onreadystatechange = function() {
       
           if (ajax.readyState==1) {
           
             
             //document.getElementById('botonesExplosion').style.left=0px;
             //document.getElementById('botones').style.top=0px;
             
           }else if(ajax.readyState==4){
                // alert(ajax.status);
                if(ajax.status==200){
                    //alert(ajax.responseText);
                    var mainGrupo=document.getElementById('panelCenter');
                    //mainGrupo.innerHTML=ajax.responseText;
                    document.write(ajax.responseText);
                    
                    //f=0;
                    //Item(codigo,f);
                }
           }
        };
        ajax.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
        ajax.send(valores);
    }
    function enviarCompras(codProgramaProduccion)
     {
        document.getElementById('contenidoExplosionCompras').style.display='';
        document.getElementById('contenidoExplosionCompras').style.zIndex = 5;
        document.getElementById('contenidoExplosionCompras').style.backgroundColor="#f2f2f2";
        document.getElementById('botonesExplosionCompras').style.display='none';
        var ajax=nuevoAjax();
        var tablaLotes=document.getElementById("form1:dataFormula");
        var selectAlmacen=document.getElementById("formCompras:codAlmacen");
        var selectTipoMaterial=document.getElementById("formCompras:codTipoMaterial");
        var arrayLote=new Array();
        var codigos=new Array();
        var codAlmacen=new Array();
        var nombreAlmacen=new Array();
        var codTipoMaterial=new Array();
        var nombreTipoMaterial=new Array();
        for(var i=0;i<selectTipoMaterial.options.length;i++)
        {
            if(selectTipoMaterial.options[i].selected)
            {
                codTipoMaterial.push(selectTipoMaterial.options[i].value);
                nombreTipoMaterial.push(selectTipoMaterial.options[i].innerHTML);
            }
        }
        for(var i=0;i<selectAlmacen.options.length;i++)
        {
            if(selectAlmacen.options[i].selected)
            {
                codAlmacen.push(selectAlmacen.options[i].value);
                nombreAlmacen.push(selectAlmacen.options[i].innerHTML);
            }
        }
         for(var i=1;i<tablaLotes.rows.length;i++)
        {
            if(tablaLotes.rows[i].cells[0].getElementsByTagName("input")[0].checked)
            {
                arrayLote[arrayLote.length]="'"+tablaLotes.rows[i].cells[3].innerHTML+"$"+tablaLotes.rows[i].cells[7].getElementsByTagName("input")[0].value+"'";
                codigos.push(tablaLotes.rows[i].cells[1].getElementsByTagName("input")[0].value);
            }
        }
        if(codTipoMaterial.length==0)
        {
            alert("Debe Selecccionar por lo menos un tipo de material");
            return false;
        }
        if(codAlmacen.length==0)
        {
            alert("Debe Selecccionar por lo menos un almacen");
            return false;
        }
        var valores="codProgramaProduccion="+codProgramaProduccion+"&codigos="+codigos+"&conProductosEnProceso="+(document.getElementById("formProcesos:conProductosEnProceso").checked?1:0)+
                    "&lotes="+arrayLote+"&codAlmacen="+codAlmacen+"&nombreAlmacen="+nombreAlmacen+
                    "&codTipoMaterial="+codTipoMaterial+"&nombreTipoMaterial="+nombreTipoMaterial;
        var url='explosionMaterialesProgramaProduccionSimulacionCompras.jsf?date='+(new Date()).getTime().toString();
        
        
        ajax.open ('POST', url, true);
        ajax.onreadystatechange = function() {
       
           if (ajax.readyState==1) {
           
             
             //document.getElementById('botones').style.left=0px;
             //document.getElementById('botones').style.top=0px;
             
           }else if(ajax.readyState==4){
                // alert(ajax.status);
                if(ajax.status==200){
                    //alert(ajax.responseText);
                    var mainGrupo=document.getElementById('panelCenter');
                    //mainGrupo.innerHTML=ajax.responseText;
                    document.write(ajax.responseText);
                    
                    //f=0;
                    //Item(codigo,f);
                }
           }
        };
        ajax.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
        ajax.send(valores);
    }
    
    function seleccionarTodo(){
       //alert('entro');
       var seleccionar_todo=document.getElementById('form1:seleccionar_todo');
       var elements=document.getElementById('form1:dataFormula');

       if(seleccionar_todo.checked==true){  
         //alert('entro por verdad');
            var rowsElement=elements.rows;
            for(var i=1;i<rowsElement.length;i++){
                var cellsElement=rowsElement[i].cells;
                var cel=cellsElement[0];
                if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                    cel.getElementsByTagName('input')[0].checked=true;
                }
            }
       }
       else
       {//alert('entro por false');
            var rowsElement=elements.rows;
            for(var i=1;i<rowsElement.length;i++){
                var cellsElement=rowsElement[i].cells;
                var cel=cellsElement[0];
                if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                    cel.getElementsByTagName('input')[0].checked=false;
                }
            }

       }
       return true;

    }
    function trim (myString)
                {
                    return myString.replace(/^\s+/g,'').replace(/\s+$/g,'')
                }

     function seleccionarItem(nametable,producto,lote,check){
                    var elements=document.getElementById(nametable);
                    var rowsElement=elements.rows;
                    
                    //se verifica si esta seleccionado
                    //alert(check.checked);

                    if(check.checked==true){
                       for(var i=1;i<rowsElement.length;i++){
                        var cellsElement=rowsElement[i].cells;
                        var cel0=cellsElement[0];
                        var cel1=cellsElement[1];
                        var cel2=cellsElement[2];
                        var cel3=cellsElement[3];

                    if( trim(cel1.innerHTML) == trim(producto)  && parseFloat(cel3.innerHTML)== parseFloat(lote)  ){
                            //alert("entro 1");
                            cel0.getElementsByTagName('input')[0].checked=true;

                        }else{
                            //alert("entro 2");
                            cel0.getElementsByTagName('input')[0].checked=false;
                        }
                    }

                    }else{
                         for(var i=1;i<rowsElement.length;i++){
                        var cellsElement=rowsElement[i].cells;
                        var cel0=cellsElement[0];
                        var cel1=cellsElement[1];
                        var cel2=cellsElement[2];
                        var cel3=cellsElement[3];

                    if( trim(cel1.innerHTML) == trim(producto)  && parseFloat(cel3.innerHTML)== parseFloat(lote)  ){
                            //alert("entro 1");
                            cel0.getElementsByTagName('input')[0].checked=false;

                        }else{
                            //alert("entro 2");
                            cel0.getElementsByTagName('input')[0].checked=false;
                        }
                    }

                    }

                   
                }
                function openPopup(url){
                    window.open(url,'DETALLE','top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
                }
            </script>
</head>
<body >
    
    <div  align="center" id="panelCenter">
        <a4j:form id="form1"  >
        
        <h:outputText value="#{ManagedProgramaProduccionSimulacion.cargarProgramaProduccion1}"  />
        <h:outputText styleClass="outputTextTituloSistema"  value="Simulación de Programas de Producción " /> 
        <rich:panel headerClass="headerClassACliente" style="width:80%">
            <f:facet name="header">
                <h:outputText value="Simulacion de Programa de Produccion"/>
            </f:facet>
            <h:panelGrid columns="3">
                <h:outputText styleClass="outputTextBold" value="Programa de producción"/>
                <h:outputText styleClass="outputTextBold" value="::"/>
                <h:outputText styleClass="outputText2" value="#{ManagedProgramaProduccionSimulacion.programaProduccionbean.programaProduccionPeriodo.nombreProgramaProduccion}"/>
                <h:outputText styleClass="outputTextBold" value="Observación"/>
                <h:outputText styleClass="outputTextBold" value="::"/>
                <h:outputText styleClass="outputText2" value="#{ManagedProgramaProduccionSimulacion.programaProduccionbean.programaProduccionPeriodo.obsProgramaProduccion}"/>
                <h:outputText styleClass="outputTextBold" value="Estado Programa"/>
                <h:outputText styleClass="outputTextBold" value="::"/>
                <h:outputText styleClass="outputText2" value="#{ManagedProgramaProduccionSimulacion.programaProduccionbean.programaProduccionPeriodo.estadoProgramaProduccion.nombreEstadoProgramaProd}"/>
                <h:outputText styleClass="outputTextBold" value="Area Fabricación Producto"/>
                <h:outputText styleClass="outputTextBold" value="::"/>
                <h:selectManyMenu style="height:90px" value="#{ManagedProgramaProduccionSimulacion.codAreasFabricacionProduccionList}">
                    <f:selectItems value="#{ManagedProgramaProduccionSimulacion.areasFabricacionProduccionList}"/>
                </h:selectManyMenu>
                
            </h:panelGrid>
            <a4j:commandButton value="Buscar" action="#{ManagedProgramaProduccionSimulacion.buscarProgramaProduccion_action}" styleClass="btn"
                               reRender="dataFormula"/>
        </rich:panel>
        <br>
        <rich:dataTable value="#{ManagedProgramaProduccionSimulacion.programaProduccionList}" var="data" id="dataFormula" 
                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                        onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                        headerClass="headerClassACliente"
                        binding="#{ManagedProgramaProduccionSimulacion.programaProduccionDataTable}" >
            <h:column >
                <f:facet name="header">
                    <h:selectBooleanCheckbox onclick="seleccionarTodosCheckBox(this)"/>
                    
                </f:facet>
                <h:selectBooleanCheckbox value="#{data.checked}"/>
            </h:column>
            
            <h:column>
                <f:facet name="header">
                    <h:outputText value="Producto"  />
                </f:facet>
                <h:outputText value="#{data.formulaMaestra.componentesProd.nombreProdSemiterminado}"  />
                <h:inputHidden value="#{data.formulaMaestra.componentesProd.codCompprod}"/>
            </h:column>
             
            <h:column>
                <f:facet name="header">
                    <h:outputText value="cantidad de Lote"  />
                </f:facet>
                <h:outputText value="#{data.cantidadLote}"  />
            </h:column>
            <h:column>
                <f:facet name="header">
                    <h:outputText value="Lote"  />
                </f:facet>
                <h:outputText value="#{data.codLoteProduccion}"  />
            </h:column>
            
            <h:column>
                <f:facet name="header">
                    <h:outputText value="Area"  />
                </f:facet>
                <h:outputText value="#{data.formulaMaestra.componentesProd.areasEmpresa.nombreAreaEmpresa}"  />
            </h:column>
            <h:column>
                <f:facet name="header">
                    <h:outputText value="Forma Farmaceútica"  />
                </f:facet>
                <h:outputText value="#{data.formulaMaestra.componentesProd.forma.nombreForma}"  />
            </h:column>
            
            <h:column >
                <f:facet name="header">
                    <h:outputText value="Observación"  />
                </f:facet>
                <h:outputText value="#{data.observacion}" />
            </h:column>
            
            <h:column >
                <f:facet name="header">
                    <h:outputText value="Tipo Programa Producción"  />
                </f:facet>
                <h:outputText value="#{data.tiposProgramaProduccion.nombreProgramaProd}" />
                <h:inputHidden value="#{data.tiposProgramaProduccion.codTipoProgramaProd}"/>
            </h:column>
            <h:column >
                <f:facet name="header">
                    <h:outputText value="Presentación"  />
                </f:facet>
                <h:outputText value="#{data.presentacionesProducto.nombreProductoPresentacion}" />
            </h:column>
            <h:column >
                <f:facet name="header">
                    <h:outputText value="Estado"  />
                </f:facet>
                <h:outputText value="#{data.estadoProgramaProduccion.nombreEstadoProgramaProd}" />
            </h:column>
           
            <h:column>
                <f:facet name="header">
                    <h:outputText value=""  />
                </f:facet>
                <h:outputText value="<a  onclick=\"getCodigo('#{data.codProgramaProduccion}','#{data.formulaMaestra.codFormulaMaestra}','#{data.formulaMaestra.cantidadLote}','#{data.formulaMaestra.componentesProd.codCompprod}','#{data.codLoteProduccion}','#{data.tiposProgramaProduccion.codTipoProgramaProd}');\" style='cursor:hand;text-decoration:underline' ><img src='../img/cargos.jpg' alt='Haga click para ver Detalle'></a>  "  escape="false"  />
            </h:column>
            
        </rich:dataTable>
        
        <br>
        <div align="center" style="" id="botones"  >
            <a4j:commandButton value="Agregar" rendered="#{ManagedProgramaProduccionSimulacion.programaProduccionbean.programaProduccionPeriodo.cantProgramaProduccionPeriodoSolicitudCompra eq 0}" styleClass="btn" oncomplete="window.location.href='agregarProgramaProduccion.jsf?new+'+(new Date()).getTime().toString();"  />
            <a4j:commandButton value="Editar" rendered="#{ManagedProgramaProduccionSimulacion.programaProduccionbean.programaProduccionPeriodo.cantProgramaProduccionPeriodoSolicitudCompra eq 0}" action="#{ManagedProgramaProduccionSimulacion.editarProgramaProduccionSimulacion_action}"  styleClass="btn" oncomplete="window.location.href='editarProgramaProduccionSimulacion.jsf?new+'+(new Date()).getTime().toString();"  />
            
            <h:commandButton value="Eliminar" rendered="#{ManagedProgramaProduccionSimulacion.programaProduccionbean.programaProduccionPeriodo.cantProgramaProduccionPeriodoSolicitudCompra eq 0}"   styleClass="btn"  action="#{ManagedProgramaProduccionSimulacion.eliminarProgramaProduccion_action1}" onclick="if(confirm('Estado seguro de Eliminar?')==false){return false;}" />
            <a4j:commandButton value="Explosión Materiales"  styleClass="btn" onclick="if(!alMenosUno('form1:dataFormula')){return false;}"   oncomplete="javascript:Richfaces.showModalPanel('modalParametrosExplosion');" />
            <a4j:commandButton value="Explosión Materiales Compras"  styleClass="btn" onclick="if(!alMenosUno('form1:dataFormula')){return false;}"   oncomplete="javascript:Richfaces.showModalPanel('modalParametrosExplosionCompras');" />
            <%--h:commandButton value="Explosión Maquinaria"  styleClass="btn"  action="#{ManagedProgramaProduccionSimulacion.explosionMaquinaria}"   /--%>
            <%--a4j:commandButton value="Explosion de Maquinaria" action="#{ManagedProgramaProduccionSimulacion.explosionMaquinaria}" styleClass="btn" oncomplete="openPopup('../reportes/explosionMaquinarias/navegadorReporteExplosionMaquinarias.jsf')" /--%>
            <a4j:commandButton value="Generar Solicitud Por Explosión" styleClass="btn" action="#{ManagedProgramaProduccionSimulacion.generarSolicitudCompraPorExplosionMaquinaria_action}"
                               oncomplete="if(#{ManagedProgramaProduccionSimulacion.mensaje eq '1'}){alert('Se registro la solicitud por explosión');window.location.reload()}else{alert('#{ManagedProgramaProduccionSimulacion.mensaje}')}"
                               rendered="#{ManagedProgramaProduccionSimulacion.programaProduccionbean.programaProduccionPeriodo.cantProgramaProduccionPeriodoSolicitudCompra eq 0}"/>
            <a4j:commandButton styleClass="btn" onclick="location='navegadorProgramaProduccionPeriodoSimulacion.jsf?cancel='+(new Date()).getTime().toString()" value="Cancelar" />

        </div>
        
        <div align="center" style="visibility:hidden; " id="contenido"  >
            
            
            
            
            
            
            <p>Cargando.....</p>  
            <img src="../img/load.gif" valign="center" > 
        </div>
        
    </div>
    </a4j:form>
    <rich:modalPanel id="modalParametrosExplosion" minHeight="300" headerClass="headerClassACliente"
                                     minWidth="450" height="300" width="600" zindex="100" >
                    <f:facet name="header">
                        <h:outputText value="<center>Seleccionar Almacenes para Explosión de Materiales</center>" escape="false"/>
                    </f:facet>
                    <a4j:form id="formProcesos">
                        <center>
                            <h:panelGrid columns="3">
                                <h:outputText value="Almacen" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:selectManyMenu id="codAlmacen" style="height:10em" styleClass="inputText" value="#{ManagedProgramaProduccionSimulacion.almacenesList}">
                                    <f:selectItems value="#{ManagedProgramaProduccionSimulacion.almacenesSelectList}"/>
                                </h:selectManyMenu>
                                <h:outputText value="Con Productos en Proceso" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:selectBooleanCheckbox value="false" id="conProductosEnProceso"/>
                            </h:panelGrid>
                            <div align="center" style="" id="botonesExplosion"  >
                                <a4j:commandButton 
                                    oncomplete="enviar('#{ManagedProgramaProduccionSimulacion.programaProduccionbean.codProgramaProduccion}')"
                                                   styleClass="btn" value="Generar Explosión"/>
                                <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="Richfaces.hideModalPanel('modalParametrosExplosion')"/>
                            </div>
                            <div align="center" style="visibility:hidden; " id="contenidoExplosion"  >
                                <p>Cargando.....</p>  
                                <img src="../img/load.gif" valign="center" > 
                            </div>
                        </center>
                                           
                    </a4j:form>
                
            </rich:modalPanel>
    <rich:modalPanel id="modalParametrosExplosionCompras" minHeight="330" headerClass="headerClassACliente"
                            minWidth="450" height="330" width="600" zindex="100" >
           <f:facet name="header">
               <h:outputText value="<center>Datos para explosión de materiales compras</center>" escape="false"/>
           </f:facet>
           <a4j:form id="formCompras">
               <center>
                   <h:panelGrid columns="3">
                       <h:outputText value="Almacen" styleClass="outputTextBold"/>
                       <h:outputText value="::" styleClass="outputTextBold"/>
                       <h:selectManyMenu id="codAlmacen" style="height:10em" styleClass="inputText" value="#{ManagedProgramaProduccionSimulacion.almacenesList}">
                           <f:selectItems value="#{ManagedProgramaProduccionSimulacion.almacenesSelectList}"/>
                       </h:selectManyMenu>
                       <h:outputText value="Tipo Material" styleClass="outputTextBold"/>
                       <h:outputText value="::" styleClass="outputTextBold"/>
                       <h:selectManyMenu styleClass="inputText" id="codTipoMaterial" style="height:8em">
                           <f:selectItem itemValue="1" itemLabel="Materia Prima"/>
                           <f:selectItem itemValue="2" itemLabel="Empaque Primario"/>
                           <f:selectItem itemValue="3" itemLabel="Empaque Secundario"/>
                           <f:selectItem itemValue="4" itemLabel="Reactivos"/>
                       </h:selectManyMenu>
                       <h:outputText value="Con Productos en Proceso" styleClass="outputTextBold"/>
                       <h:outputText value="::" styleClass="outputTextBold"/>
                       <h:selectBooleanCheckbox value="false" id="conProductosEnProceso"/>
                   </h:panelGrid>
                   <div align="center" style="" id="botonesExplosionCompras"  >
                        <a4j:commandButton 
                            oncomplete="enviarCompras('#{ManagedProgramaProduccionSimulacion.programaProduccionbean.codProgramaProduccion}')"
                                           styleClass="btn" value="Generar Explosión"/>
                        <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="Richfaces.hideModalPanel('modalParametrosExplosionCompras')"/>
                   </div>
                   <div align="center" style="display:none; " id="contenidoExplosionCompras"  >
                        <span>Cargando.....</span>  
                        <img src="../img/load.gif" valign="center" > 
                    </div>
               </center>

           </a4j:form>

   </rich:modalPanel>
    <a4j:status id="statusPeticion"
                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
     </a4j:status>

    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                     minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

        <div align="center">
            <h:graphicImage value="../img/load2.gif" />
        </div>
    </rich:modalPanel>
</body>
</html>

</f:view>

