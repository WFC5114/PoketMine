using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Numerics;

public class UIManager : MonoBehaviour
{
    public ContractInteractor contractInteractor;

    public void OnGetAttributesButtonClicked()
    {
        BigInteger tokenId = BigInteger.Parse("1"); //Token ID
        contractInteractor.GetCreatureAttributes(tokenId);
    }
}

