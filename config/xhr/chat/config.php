<?php

$id_auteur=0;
$date_publication=new \DateTime($config['chat_voir_conversation_temps_0']);
$date_comparaison=new \DateInterval($config['chat_voir_conversation_date_comparaison']);
$date_custom=new \DateTime(date('Y-m-d H:i:s'));

$date_chargement=$date_publication;
if (isset($_GET['date_chargement']))
{
	$date_chargement=new \DateTime($_GET['date_chargement']);
}
if (isset($_GET['id']))
{
	$id=(int)$_GET['id'];
	$Conversation=new \chat\Conversation(array(
		'id' => $id,
	));
	$Conversation->recuperer($date_chargement->format('Y-m-d H:i:s'));
	$Utilisateurs=$Conversation->getUtilisateurs();
	$index=0;
	while (isset($Utilisateurs[$index]) & $Utilisateurs[$index]->similaire($Visiteur))		// Évite de parcourir toute la liste
	{
		$index++;
	}
	if (!$Utilisateurs[$index])
	{
		throw new \Exception($lang['chat_voir_conversation_erreur_pas_membre']);
	}
}
else
{
	throw new \Exception($lang['chat_voir_conversation_erreur_no_id']);
}


$MessagesElements=[];
foreach ($Conversation->getMessages() as $Message)
{
	$date_message=new \DateTime($Message->afficherDate_publicationFormat('Y-m-d H:i:s'));
	if ($date_message>$date_chargement)	// Normalement c'est tout le temps vrai (opti de $Conversation->recuperer())
	{
		$date_comparaison1=clone $date_custom;
		$date_comparaison2=clone $date_custom;
		$Detail_message='';
		$Separation='';
		$date_diff=$date_publication->diff($date_message, True);
		$date_comparaison1->add($date_comparaison);
		$date_comparaison2->add($date_diff);
		if ($Message->getId_auteur()!=$id_auteur | $date_comparaison1<$date_comparaison2)
		{
			$Auteur=new \user\Utilisateur(array(
				'id' => $Message->getId_auteur(),
			));
			$Auteur->recuperer();
			$id_auteur=$Auteur->getId();
			$date_publication=new \DateTime($Message->afficherDate_publicationFormat('Y-m-d H:i:s'));

			$Detail_message=new \user\PageElement(array(
				'template' => $config['path_template'].'chat'.'/'.'voir_conversation'.'/detail_message.html',
				'elements' => array(
					'auteur' => $lang['chat_voir_conversation_auteur'].$Auteur->afficherPseudo(),
					'date'   => $lang['chat_voir_conversation_date'].$Message->afficherDate_publication(),
				),
			));

			$Separation=new \user\PageElement(array(
				'template' => $config['path_template'].'chat'.'/'.'voir_conversation'.'/separation.html',
				'elements' => array(),
			));
		}

		$Contenu_message=new \user\PageElement(array(
			'template' => $config['path_template'].'chat'.'/'.'voir_conversation'.'/contenu_message.html',
			'elements' => array(
				'contenu' => $Message->afficherContenu(),
			),
		));

		$MessagesElements[]=new \user\PageElement(array(
			'template' => $config['path_template'].'chat'.'/'.'voir_conversation'.'/message.html',
			'elements' => array(
				'detail_message'  => $Detail_message,
				'contenu_message' => $Contenu_message,
				'separation'      => $Separation,
			),
		));
	}
}

$Chat=new \user\PageElement(array(
	'template' => $config['path_template'].'chat'.'/'.'voir_conversation'.'/chat.html',
	'fonctions' => $config['path_func'].'chat'.'/'.'voir_conversation'.'/chat.func.php',
	'elements' => array(
		'messages' => $MessagesElements,
	),
));

$Corps=new \user\page\Corps('', $Carte, '');

$Visiteur->getPage()->getPageElement()->ajouterElement($config['corps_nom'], $Corps);

?>