<?php

$titre=$lang['user_edition_titre'];
$config['metas'][]=array(
	'name'    => 'description',
	'content' => $lang['user_edition_description'],
);

$admin=False;
$partie_admin='';
$Utilisateur=$Visiteur;
if(isset($_GET['id']) & $Visiteur->getRole()->existPermission($config['user_edition_admin_application'], $config['user_edition_admin_action']))
{
	$admin=True;
	$Utilisateur=new \user\Utilisateur(array(
		'id' => $_GET['id'],
	));
	$Utilisateur->recuperer();
	$config['user_edition_action']=$config['user_edition_action'].'&id='.$_GET['id'];
	$checked='';
	if($Utilisateur->getBanni())
	{
		$checked=' checked=""';
	}
	$partie_admin=new \user\PageElement(array(
		'template' => $config['path_template'].$application.'/'.$action.'/partie_admin.html',
		'elements' => array(
			'label_banni' => $lang['user_edition_label_banni'],
			'checked'     => $checked,
		),
	));
}

$Contenu=new \user\PageElement(array(
	'template' => $config['path_template'].$application.'/'.$action.'/form.html',
	'elements' => array(
		'action'       => $config['user_edition_action'],
		'legend'       => $lang['user_edition_legend'].$Utilisateur->afficherPseudo(),
		'label_avatar' => $lang['user_edition_label_avatar'],
		'avatar'       => $Utilisateur->afficherAvatar(),
		'label_mail'   => $lang['user_edition_label_mail'],
		'mail'         => $Utilisateur->afficherMail(),
		'partie_admin' => $partie_admin,
		'submit'       => $lang['user_edition_submit'],
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