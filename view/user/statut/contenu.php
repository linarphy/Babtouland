<?php ob_start(); ?>
	<div id="conteneur">
		<section class="ligne">
			<section class="colonne">
				<section class="carte">
					<section class="contenu">
						<?= $lang['user_statut_pseudo'] ?><?= $Visiteur->afficherPseudo() ?><br />
						<?= $lang['user_statut_avatar'] ?><?= $Visiteur->afficherAvatar() ?><br />
						<?= $lang['user_statut_derndateco'] ?><?= $Visiteur->afficherDate_connexion() ?><br />
						<?= $lang['user_statut_premdatein'] ?><?= $Visiteur->afficherDate_inscription() ?>
					</section>
				</section>
			</section>
		</section>
	</div>
<?php $contenu=ob_get_clean(); ?>