<?php

$Message=new \user\Message(array(
	'contenu'  => $lang['user_validation_edition_message_formulaire'],
	'type'     => \user\Message::TYPE_ERREUR,
	'css'      => $config['message_css'],
	'js'       => $config['message_js'],
	'template' => $config['message_template'],
));
$get=$config['user_validation_edition_lien_erreur_formulaire'];
if((isset($_FILES['edition_avatar']) & !empty($_FILES['edition_avatar'])) | (isset($_POST['edition_mail']) & !empty($_POST['mail'])) | $Visiteur->getRole()->existPermission($config['user_edition_admin_application'], $config['user_edition_admin_action']))
{
	$Message=new \user\Message(array(
		'contenu'  => $lang['user_validation_edition_message_succes'],
		'type'     => \user\Message::TYPE_SUCCES,
		'css'      => $config['message_css'],
		'js'       => $config['message_js'],
		'template' => $config['message_template'],
	));
	$get=$config['user_validation_edition_lien_succes'];
	$id=$Visiteur->getId();
	$banni=$Visiteur->getBanni();
	$avatar=$Visiteur->getAvatar();
	if(isset($_GET['id']) & $Visiteur->getRole()->existPermission($config['user_edition_admin_application'], $config['user_edition_admin_action']))	// On change quelqu'un d'autre
	{
		$id=(int)$_GET['id'];
		$Message=new \user\Message(array(
			'contenu'  => $lang['user_validation_edition_message_admin_succes'],
			'type'     => \user\Message::TYPE_SUCCES,
			'css'      => $config['message_css'],
			'js'       => $config['message_js'],
			'template' => $config['message_template'],
		));
		$get=$config['user_validation_edition_lien_admin_succes'].'&id='.$id;
		$Utilisateur=new \user\Utilisateur(array(
			'id' => $id,
		));
		$Utilisateur->recuperer();
		$avatar=$Utilisateur->getAvatar();
		$banni=False;
		if(isset($_POST['edition_banni']))
		{
			$banni=True;
		}
	}
	if(isset($_FILES['edition_avatar']) & !empty($_FILES['edition_avatar']))	// Avatar changé
	{
		/************************************************************
		 * Script realise par Emacs
		 * Crée le 19/12/2004
		 * Maj : 23/06/2008
		 * Licence GNU / GPL
		 * webmaster@apprendre-php.com
		 * http://www.apprendre-php.com
		 * http://www.hugohamon.com
		 *
		 * Changelog:
		 *
		 * 2008-06-24 : suppression d'une boucle foreach() inutile
		 * qui posait problème. Merci à Clément Robert pour ce bug.
		 *
		 *************************************************************/
		 
		/************************************************************
		 * Definition des constantes / tableaux et variables
		 *************************************************************/
		 
		// Constantes
		define('TARGET', $config['chemin_avatar']);    // Repertoire cible
		define('MAX_SIZE', $config['size_avatar']);    // Taille max en octets du fichier
		define('WIDTH_MAX', $config['width_avatar']);    // Largeur max de l'image en pixels
		define('HEIGHT_MAX', $config['height_avatar']);    // Hauteur max de l'image en pixels
		 
		// Tableaux de donnees
		$tabExt = $config['ext_avatar'];    // Extensions autorisees
		$infosImg = array();
		$fichier='edition_avatar';
		 
		// Variables
		$extension = '';
		$message = '';
		$nomImage = '';
		 
		/************************************************************
		 * Creation du repertoire cible si inexistant
		 *************************************************************/
		if( !is_dir(TARGET) ) {
		  if( !mkdir(TARGET, 0755) ) {
		  	$Message=new \user\Message(array(
		  		'contenu'  => $lang['user_validation_edition_avatar_message_erreur_dossier'],
				'type'     => \user\Message::TYPE_ERREUR,
				'css'      => $config['message_css'],
				'js'       => $config['message_js'],
				'template' => $config['message_template'],
			));
		    $get=$config['user_validation_edition_avatar_lien_erreur_dossier'];
		  }
		}
		 
		/************************************************************
		 * Script d'upload
		 *************************************************************/
		if(!empty($_POST))
		{

		    // Recuperation de l'extension du fichier
		    $extension  = pathinfo($_FILES[$fichier]['name'], PATHINFO_EXTENSION);
		 
		    // On verifie l'extension du fichier
		    if(in_array(strtolower($extension),$tabExt))
		    {
		      // On recupere les dimensions du fichier
		      $infosImg = getimagesize($_FILES[$fichier]['tmp_name']);
		 
		      // On verifie le type de l'image
		      if($infosImg[2] >= 1 && $infosImg[2] <= 14)
		      {
		        // On verifie les dimensions et taille de l'image
		        if(($infosImg[0] <= WIDTH_MAX) && ($infosImg[1] <= HEIGHT_MAX) && (filesize($_FILES[$fichier]['tmp_name']) <= MAX_SIZE))
		        {
		          // Parcours du tableau d'erreurs
		          if(isset($_FILES[$fichier]['error']) 
		            && UPLOAD_ERR_OK === $_FILES[$fichier]['error'])
		          {
		            // On renomme le fichier
		            $nomImage = md5(uniqid()) .'.'. $extension;
		 
		            // Si c'est OK, on teste l'upload
		            if(move_uploaded_file($_FILES[$fichier]['tmp_name'], TARGET.$nomImage))
		            {
		              $avatar=$nomImage;
		            }
		            else
		            {
					// Sinon on affiche une erreur systeme
					$Message=new \user\Message(array(
						'contenu'  => $lang['user_validation_edition_avatar_message_erreur_upload'],
						'type'     => \user\Message::TYPE_ERREUR,
						'css'      => $config['message_css'],
						'js'       => $config['message_js'],
						'template' => $config['message_template'],
					));
					$get=$config['user_validation_edition_avatar_lien_erreur_upload'];
		            }
		          }
		          else
		          {
		          	$Message=new \user\Message(array(
		          		'contenu'  => $lang['user_validation_edition_avatar_message_erreur_interne'],
						'type'     => \user\Message::TYPE_ERREUR,
						'css'      => $config['message_css'],
						'js'       => $config['message_js'],
						'template' => $config['message_template'],
					));
		          	$get=$config['user_validation_edition_avatar_lien_erreur_interne'];
		          }
		        }
		        else
		        {
					// Sinon erreur sur les dimensions et taille de l'image
					$Message=new \user\Message(array(
			          	'contenu'  => $lang['user_validation_edition_avatar_message_erreur_dimension'],
						'type'     => \user\Message::TYPE_ERREUR,
						'css'      => $config['message_css'],
						'js'       => $config['message_js'],
						'template' => $config['message_template'],
					));
					$get=$config['user_validation_edition_avatar_lien_erreur_dimension'];
		        }
		      }
		      else
		      {
		        // Sinon erreur sur le type de l'image
		        $Message=new \user\Message(array(
		        	'contenu'  => $lang['user_validation_edition_avatar_message_erreur_type'],
					'type'     => \user\Message::TYPE_ERREUR,
					'css'      => $config['message_css'],
					'js'       => $config['message_js'],
					'template' => $config['message_template'],
				));
		        $get=$config['user_validation_edition_avatar_lien_erreur_type'];
		      }
		    }
		    else
		    {
		      // Sinon on affiche une erreur pour l'extension
		      $Message=new \user\Message(array(
		      	'contenu'  => $lang['user_validation_edition_avatar_message_erreur_extension'],
				'type'     => \user\Message::TYPE_ERREUR,
				'css'      => $config['message_css'],
				'js'       => $config['message_js'],
				'template' => $config['message_template'],
			  ));
		      $get=$config['user_validation_edition_avatar_lien_erreur_extension'];
		    }
		}

		/*---------------------------------------------------------- FIN DU SCRIPT -----------------------------------------------------------------*/
	}
	$Utilisateur=new \user\Visiteur(array(
		'id'     => $id,
		'avatar' => $avatar,
		'banni'  => $banni,
		'mail'   => $_POST['edition_mail'],
	));
	$Utilisateur->mettre_a_jour();
}

$_SESSION['message']=serialize($Message);
header('location: index.php'.$get)

?>