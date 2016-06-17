using UnityEditor;
using UnityEngine;

namespace SimpleSweeps {

	/// <summary>
	/// Extension methods for MaterialProperty used in SimpleSweepsEditor.
	/// </summary>
	public static class SimpleSweepsEditorExtensions {

		/// <summary>
		/// Returns a matching MaterialProperty 
		/// </summary>
		/// <param name="properties"></param>
		/// <param name="v"></param>
		/// <returns>MaterialProperty</returns>
		public static MaterialProperty GetPropertyByName (this MaterialProperty[] properties, string v)
		{
			for (int i = 0; i < properties.Length; i++) {
				if (properties[i].name.Equals(v))
					return properties[i];
			}

			throw new UnassignedReferenceException("SimpleSweepsEditorExtentions: GetPropertyByName failed to find a match.");
		}

		/// <summary>
		/// Renders a texture field and Vector4 field for handling the effect properties of a specific mask color channel.
		/// </summary>
		/// <param name="materialEditor"></param>
		/// <param name="label"></param>
		/// <param name="textureProperty"></param>
		/// <param name="settingsProperty"></param>
		public static void TextureEffectProperty (this MaterialEditor materialEditor, string label, MaterialProperty textureProperty, MaterialProperty settingsProperty)
		{
			EditorGUILayout.BeginHorizontal();
			{
				EditorGUILayout.PrefixLabel(label, EditorStyles.helpBox, EditorStyles.boldLabel);
				EditorGUILayout.HelpBox(settingsProperty.displayName, MessageType.None);
			}
			EditorGUILayout.EndHorizontal();

			materialEditor.TexturePropertySingleLine(new GUIContent(textureProperty.displayName), textureProperty, settingsProperty);
			materialEditor.TextureScaleOffsetProperty(textureProperty);
		}
	}

}

