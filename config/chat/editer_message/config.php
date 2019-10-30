<?php

if (isset($_GET['id']))
{
	$ChatMessage=new \chat\Message(array(
		'id' => $_GET['id'],
	));
	$ChatMessage->recuperer();
	$Conversation=new \chat\Conversation(array(
		'id' => $ChatMessage->getId_conversation(),
	));
	$date_maintenant=new \DateTime(date('Y-m-d H:i:s'));
	$Conversation->recuperer($date_maintenant->format('Y-m-d H:i:s'));
	$Id_utilisateurs=$Conversation->getId_utilisateurs();
	$index=0;
	while (isset($Id_utilisateurs[$index]) & $Id_utilisateurs[$index]==$Visiteur->getId())		// Évite de parcourir toute la liste
	{
		$index++;
	}
	if ($Id_utilisateurs[$index])	// Accès à la conversation
	{
		if(autorisationModification($ChatMessage, $application, $action))	// On peut le modifier
		{

			$Visiteur->getPage()->getPageElement()->getElement($config['tete_nom'])->ajouterElement('titre', $lang[$Visiteur->getPage()->getApplication().'_'.$Visiteur->getPage()->getAction().'_titre']);
			$Visiteur->getPage()->getPageElement()->getElement($config['tete_nom'])->ajouterValeurElement('metas', array(
				'name'    => 'description',
				'content' => $lang[$Visiteur->getPage()->getApplication().'_'.$Visiteur->getPage()->getAction().'_description'],
			));

			$Contenu=new \user\PageElement(array(
				'template' => $config['path_template'].$application.'/'.$action.'/form.html',
				'elements' => array(
					'action'         => $config['chat_editer_message_form_action'].'&id='.$ChatMessage->afficherId(),
					'legend'         => $lang['chat_editer_message_form_legend'],
					'label_message'  => $lang['chat_editer_message_form_label_message'],
					'ancien_message' => $ChatMessage->afficherContenu(),
					'submit'         => $lang['chat_editer_message_form_submit'],
				),
			));

			$Formulaire=new \user\page\Formulaire($Contenu, $Visiteur->getPage()->getPageElement()->getElement($config['tete_nom']));

			$Contenu=new \user\PageElement(array(
				'template'  => $config['path_template'].$application.'/'.$action.'/'.$config['filename_contenu_template'],
				'fonctions' => $config['path_func'].$application.'/'.$action.'/'.$config['filename_contenu_fonctions'],
				'elements' => array(
					'formulaire' => $Formulaire,
				),
			));

			$Carte=new \user\page\Carte($Contenu, $Visiteur->getPage()->getPageElement()->getElement($config['tete_nom']));
			$MenuUp=new \user\page\MenuUp($Visiteur->getPage()->getpageElement()->getElement($config['tete_nom']));
			$Corps=new \user\page\Corps($MenuUp, $Carte, '');

			$Visiteur->getPage()->getPageElement()->ajouterElement($config['corps_nom'], $Corps);
		}
		else
		{
			$Notification=new \user\page\Notification(array(
				'type'    => \user\page\Notification::TYPE_ERREUR,
				'contenu' => $lang['chat_editer_message_erreur_message_autorisation'],
			));
			$this->getPage()->envoyerNotificationsSession();
			header('location: index.php'.$config['chat_editer_message_erreur_message_autorisation']);
		}
	}
	else
	{
		$Notification=new \user\page\Notification(array(
			'type'    => \user\page\Notification::TYPE_ERREUR,
			'contenu' => $lang['chat_editer_message_erreur_conversation_autorisation'],
		));
		$this->getPage()->envoyerNotificationsSession();
		header('location: index.php'.$config['chat_editer_message_erreur_conversation_autorisation']);
	}
}
else
{
	$Notification=new \user\page\Notification(array(
		'type'    => \user\page\Notification::TYPE_ERREUR,
		'contenu' => $lang['chat_editer_message_erreur_id_message'],
	));
	$this->getPage()->envoyerNotificationsSession();
	header('location: index.php'.$config['chat_editer_message_erreur_id_message']);
}

?>