
// Translate e4x (JavaScript) node into a DOM node
sv.tools.e4x2dom.importNode = function(e4x, doc) {
	var me = this.importNode, xhtml, domTree, importMe;
	me.Const = me.Const || { mimeType: 'text/xml' };
	me.Static = me.Static || {};
	me.Static.parser = me.Static.parser || new DOMParser;
	xhtml = <testing
		xmlns:html="http://www.w3.org/1999/xhtml"
		xmlns:svg="http://www.w3.org/2000/svg"
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
		xmlns="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul"/>;
	xhtml.test = e4x;
	domTree = me.Static.parser.parseFromString( xhtml.toXMLString().
		replace( />\n *</g, "><" ), me.Const.mimeType);
	importMe = domTree.documentElement.firstChild;
	while(importMe && importMe.nodeType != 1)
		importMe = importMe.nextSibling;
	if(!doc) doc = document;
	return importMe ? doc.importNode(importMe, true) : null;
}

// Append an e4x node to a DOM node
sv.tools.e4x2dom.appendTo = function(e4x, node, doc) {
	return(node.appendChild(this.importNode(e4x, doc || node.ownerDocument)));
}

// Append an e4x node to a DOM node, clearing it first
sv.tools.e4x2dom.setContent = function(e4x, node) {
	this.clear(node);
	this.appendTo(e4x, node);
}

// Append an e4x node to a DOM node, clear first or not depending on 'i'
sv.tools.e4x2dom.append = function(e4x, node, i) {
	if (i == 0) {
		this.setContent(e4x, node);
	} else {
		this.appendTo(e4x, node);
	}
}

// Clear a DOM node
sv.tools.e4x2dom.clear = function(node) {
	while(node.firstChild)
		node.removeChild(node.firstChild);
}

// Translate a DOM node into an e4x (JavaScript) node
sv.tools.e4x2dom.d4e = function(domNode) {
	var xmls = new XMLSerializer();
	return(new XML(xmls.serializeToString(domNode)));
}

