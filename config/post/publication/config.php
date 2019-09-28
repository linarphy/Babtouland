<?php

$titre=$lang[$application.'_'.$action.'_titre'];
$config['metas'][]=array(
	'name'    => 'description',
	'content' => $lang[$application.'_'.$action.'_description'],
);

$Contenu=new \user\PageElement(array(
	'template' => $config['path_template'].$application.'/'.$action.'/form.html',
	'elements' => array(
		'action'        => $config['post_publication_action'],
		'legend'        => $lang['post_publication_legend'],
		'label_titre'   => $lang['post_publication_titreForm'],
		'label_contenu' => $lang['post_publication_contenu'],
		'submit'        => $lang['post_publication_submit'],
	),
));

require $config['pageElement_formulaire_req'];

$Contenu=new \user\PageElement(array(
	'template'  => $config['path_template'].$application.'/'.$action.'/'.$config['filename_contenu_template'],
	'fonctions' => $config['path_func'].$application.'/'.$action.'/'.$config['filename_contenu_fonctions'],
	'elements'  => array(
		'formulaire' => $Formulaire,
	),
));

require $config['pageElement_carte_req'];

require $config['pageElement_menuUp_req'];

$Corps=new \user\PageElement(array(
	'template'  => $config['pageElement_corps_template'],
	'fonctions' => $config['pageElement_corps_fonctions'],
	'elements'  => array(
		'haut'   => $MenuUp,
		'centre' => $Carte,
		'bas'    => '',
	),
));

$Tete=new \user\PageElement(array(
	'template'  => $config['pageElement_tete_template'],
	'fonctions' => $config['pageElement_tete_fonctions'],
	'elements'  => array(
		'metas'       => $config['metas'],
		'titre'       => $titre,
		'css'         => $config['css'],
		'javascripts' => $config['javascripts'],
	),
));

$config['pageElement_elements']['tete']=$Tete;
$config['pageElement_elements']['corps']=$Corps;

?>