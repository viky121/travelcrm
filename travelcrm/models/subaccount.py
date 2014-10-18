# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey,
    UniqueConstraint,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class Subaccount(Base):
    __tablename__ = 'subaccount'
    __table_args__ = (
        UniqueConstraint(
            'name',
            name='unique_idx_name_subaccount',
        ),
    )

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_subaccount",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    account_id = Column(
        Integer(),
        ForeignKey(
            'account.id',
            name='fk_subaccount_account_id',
            onupdate='cascade',
            ondelete='restrict',
        )
    )
    name = Column(
        String(length=255),
        nullable=False,
    )
    descr = Column(
        String(length=255),
    )

    resource = relationship(
        'Resource',
        backref=backref(
            'subaccount',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    account = relationship(
        'Account',
        backref=backref(
            'subaccounts',
            uselist=True,
            lazy='dynamic',
        ),
        uselist=False,
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)